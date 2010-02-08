module Polynome
  class Table
    class MonomeNameNotAvailableError       < StandardError ; end
    class MonomeNameNotSpecifiedError       < StandardError ; end
    class MonomeNameUnknownError            < StandardError ; end
    class MonomeCreationError               < StandardError ; end
    class ConnectionNameAlreadyExistsError  < StandardError ; end
    class ApplicationNameUnknownError       < StandardError ; end

    include Loggable

    attr_reader :listener, :sender

    def initialize(params={})
      params.reverse_merge!(
                            :inport  => Defaults.table_inport,
                            :outport => Defaults.table_outport,
                            :host    => Defaults.outhost,
                            :logger  => Defaults.logger,
                            :debug   => Defaults.debug?,
                            :name    => 'Table'
                            )

      @host                       = params[:host]
      @debug                      = params[:debug]
      @logger                     = params[:logger]
      @name                       = params[:name]
      @ignore_connection_validity = params[:ignore_connection_validity]
      @frame_buffer               = SizedQueue.new(Defaults.frame_buffer_size)
      @rack                       = Rack.new(@frame_buffer)
      @inport                     = params[:inport]
      @monomes                    = {}
      @connection_names           = []
      @connections                = []
      @logger_char                = 'T'


      log "INIT", "Table initialized. Waiting for monomes to be added and to be started..."
    end

    def boot
      log "\n\n\n\n   ************************\n   *   Table is Booting   *\n   ************************\n\n"

      @listener = OSCListener.new(@inport, :host => @host, :prefix => '/polynome/table/', :owner => @name)
      @listener.add_method('register', 'ssiss') {|mesg| log "foo" ; receive_register_client(mesg)}

      start_comms
      start
    end

    def receive_register_client(mesg=nil)
      app_name, device, port, host, prefix = *mesg.args
      log "Registering client with name: #{app_name} and device #{device} on #{host}:#{port} with prefix #{prefix}"
      add_app(
              :name          => app_name,
              :device        => device,
              :outport       => port,
              :inport        => fetch_new_app_port,
              :client_host   => host,
              :host          => @host,
              :client_prefix => prefix
              )


      connect(:app => app_name, :quadrant => 1, :rotation => 0)
    end

    def add_app(params = {})
      application = Application.new(params)
      log "Adding application with name #{params[:name]}"
      @rack << application

      log "Connecting application with name #{params[:name]} to quadrant #{1} at rotation #{0}"
      self
    end

    def fetch_new_app_port
      3334
    end

    def connect(opts={})
      opts.reverse_merge! :surface => "base", :monome => "main"
      opts.reverse_merge! :name => "#{opts[:monome]}/#{opts[:app]}"

      app     = app(opts[:app])
      monome  = monome(opts[:monome])

      log "Connecting app: #{app}"
      if @connection_names.include?(opts[:name]) then
        raise ConnectionNameAlreadyExistsError,
        "Connection name already taken, please select another"
      end

      surface = find_or_create_surface(opts[:monome], opts[:surface])

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

    def add_monome(params={})

      params.reverse_merge! :name => "main"
      unless params[:name] then
        raise MonomeNameNotSpecifiedError,
        "You need to specify a name for the monome"
      end

      log "Adding monome with name '#{params[:name]}'"

      if @monomes[params[:name]] then
        raise MonomeNameNotAvailableError,
        "This name has already been taken. Please choose another for your monome"
      end

      new_monome = Monome.new(params)

      unless new_monome.has_real_communicator? || @ignore_connection_validity then
        raise MonomeCreationError,
        "Unable to connect to the monome. Perhaps the following io_file is incorrect: "\
        "#{params[:io_file]}."
      end

      @monomes[params[:name].to_s] = new_monome
      self
    end

    def next_surface(monome_name)
      monome(monome_name).carousel.next
    end

    def prev_surface(monome_name)
      monome(monome_name).carousel.previous
    end

    def jump_to_surface(monome_name, surface_name)
      monome(monome_name).carousel.switch_to(surface_name)
    end

    def inspect
      connection_list = @connections.map{|conn| "name: #{conn[:name]}, app: #{conn[:app].name}, monome: #{conn[:monome].name}, surface: #{conn[:surface].name}, projection: #{conn[:projection].inspect}"}.inspect.color(:cyan)
      "Table, \n  monomes: #{@monomes.inspect}\n  rack: #{@rack.inspect}\n  connections: #{connection_list}\n"
    end

    def start_comms
      log "Starting Comms"
      @listener.start
    end

    def stop_comms
      log "Stopping Comms"
      @listener.stop if @listener
      # @sender.stop if @sender
    end

    def shutdown
      log "Shutdown"
      stop_comms
    end

    private

    def start

      @thread = Thread.new do
        @monomes.values.each{|monome| monome.listen}
        log "READY", "The table is laid. Now listening for button events..."

        loop do
          update_frame
          sleep 0.001 # don't update the device faster than it can handle!
        end

      end
    end

    def app(name)
      app = @rack.find_application_by_name(name)

      unless app then
        raise ApplicationNameUnknownError,
        "Application with name #{name} unknown. Please specify a "\
        "name of an application has already been registered."
      end

      return app
    end

    def monome(name = "main")
      monome = @monomes[name.to_s]

      unless monome then
        raise MonomeNameUnknownError,
        "Monome with name '#{name}' unknown. Please specify "\
        "a name of a monome that has already been registered."
      end

      return monome
    end

    def monomes
      @monomes.values
    end

    def find_or_create_surface(monome_name, surface_name)
      monome = @monomes[monome_name]
      begin
        return monome.carousel.fetch(surface_name)
      rescue Surface::UnknownSurfaceError
        return monome.carousel.add(surface_name)
      end
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
