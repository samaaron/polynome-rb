module Polynome
  class Table
    class MonomeNameNotAvailableError < StandardError ; end
    class MonomeNameNotSpecifiedError < StandardError ; end
    class MonomeNameUnknownError      < StandardError ; end

    def initialize
      @frame_buffer = SizedQueue.new(Defaults::FRAME_BUFFER_SIZE)
      @rack = Rack.new(@frame_buffer)
      @monomes = {}
    end

    def register_application(application_name, opts={})
      opts.reverse_merge! :surface => "base"

      unless monome(opts[:monome]) then
        raise MonomeNameUnknownError,
        "Monome name unknown. Please specify a name of a monome that "\
        "has already been registered"
      end

      monome(opts[:monome]).carousel.fetch(opts[:surface]).register_application(app(application_name), opts)
    end

    def add_app(opts={})
      new_app = Application.new(opts)
      @rack << new_app
      new_app
    end

    def add_monome(opts={})
      unless opts[:name] then
        raise MonomeNameNotSpecifiedError,
        "You need to specify a name for the monome"
      end

      if @monomes[opts[:name]] then
        raise MonomeNameNotAvailableError,
        "This name has already been taken. Please choose another for your monome"
      end
      new_monome = Monome.new(opts)
      @monomes[opts[:name]] = new_monome
      new_monome
    end

    def app(name)
      @rack.find_application_by_name(name)
    end

    def monome(name)
      @monomes[name.to_s]
    end

    def monomes
      @monomes.values
    end

    def apps
      @rack.applications
    end

    private

    def update_frame
      frame_update = @frame_buffer.pop
      monomes.each {|m| m.process_frame_update(frame_update)}
    end
  end
end
