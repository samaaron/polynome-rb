module Polynome
  class Table
    class MonomeNameNotAvailableError < StandardError ; end
    class MonomeNameNotSpecifiedError < StandardError ; end

    def initialize
      @frame_buffer = SizedQueue.new(Defaults::FRAME_BUFFER_SIZE)
      @rack = Rack.new(@frame_buffer)
      @monomes = {}
    end

    def add_app(opts={})
      @rack << Application.new(opts)
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

      @monomes[opts[:name]] = Monome.new(opts)
    end

    def monome(name)
      @monomes[name.to_s]
    end

    def app(name)
      @rack.find_application_by_name(name)
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
