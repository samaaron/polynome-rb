module Polynome
  class Table
    class MonomeNameNotAvailableError       < StandardError ; end
    class MonomeNameNotSpecifiedError       < StandardError ; end
    class MonomeNameUnknownError            < StandardError ; end
    class ConnectionNameAlreadyExistsError  < StandardError ; end
    class ApplicationNameUnknownError       < StandardError ; end

    def initialize
      @frame_buffer = SizedQueue.new(Defaults::FRAME_BUFFER_SIZE)
      @rack = Rack.new(@frame_buffer)
      @monomes = {}
      @connection_names = []
      @connections = []
    end

    def connect(opts={})
      opts.reverse_merge! :surface => "base", :monome => "main"
      opts.reverse_merge! :name => "#{opts[:monome]}/#{opts[:app]}"

      app     = app(opts[:app])
      monome  = monome(opts[:monome])

      if @connection_names.include?(opts[:name]) then
        raise ConnectionNameAlreadyExistsError,
        "Connection name already taken, please select another"
      end

      unless monome then
        raise MonomeNameUnknownError,
        "Monome with name #{opts[:monome]} unknown. Please specify"\
        "a name of a monme that has already been registered."
      end

      unless app then
        raise ApplicationNameUnknownError,
        "Application with name #{opts[:app]} unknown. Please specify a "\
        "name of an application has already been registered."
      end

      surface = surface(opts[:monome], opts[:surface])
      projection = surface.register_application(app, opts)

      @connections << {
        :name => opts[:name],
        :app => app,
        :monome => monome,
        :surface => surface,
        :projection => projection
      }
      self
    end

    def add_app(opts={})
      new_app = Application.new(opts)
      @rack << new_app
      self
    end

    def add_monome(opts={})
      opts.reverse_merge! :name => "main"
      unless opts[:name] then
        raise MonomeNameNotSpecifiedError,
        "You need to specify a name for the monome"
      end

      if @monomes[opts[:name]] then
        raise MonomeNameNotAvailableError,
        "This name has already been taken. Please choose another for your monome"
      end
      new_monome = Monome.new(opts)
      @monomes[opts[:name].to_s] = new_monome
      self
    end

    def start
      @thread = Thread.new do
        loop do
          update_frame
          sleep 0.01
        end
      end
    end

    def inspect
      "Table, \n  monomes: #{@monomes.inspect}\n  rack: #{@rack.inspect}\n  connections: #{@connections.inspect}\n"
    end

    private

    def app(name)
      @rack.find_application_by_name(name)
    end

    def monome(name = "main")
      @monomes[name.to_s]
    end

    def monomes
      @monomes.values
    end

    def surface(monome_name, surface_name)
      @monomes[monome_name].carousel.fetch(surface_name)
    end

    def apps
      @rack.applications
    end

    def update_frame
      frame_update = @frame_buffer.pop
      monomes.each {|m| m.process_frame_update(frame_update)}
    end

    def connections
      @connections
    end

    def frame_buffer_size
      @frame_buffer.size
    end
  end
end
