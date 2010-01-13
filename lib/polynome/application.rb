module Polynome
  # The representation of an application. An application is a representation of an external app which is communicated to via OSC messages.
  # Each application has a given type - which maps onto one of the available monome models (64, 128, 256). 128 apps can also optionally specify
  # an orientation (landscape or portrait) which will affect the available coordinates. Each application also has a unique name which is used to
  # identify it.
  #
  # Applications communicate with Polynome through a frame buffer onto which it pushes frames to be displayed.


  class Application
    attr_reader :name, :model, :device
    attr_accessor :frame_buffer

    def initialize(opts = {})
      opts.reverse_merge! :orientation => :landscape

      unless opts[:model] then
        raise ArgumentError,
        "Polynome::Application#initialize requires a "\
        "model to be specified",
        caller
      end

      unless opts[:name] then
        raise ArgumentError,
        "Polynome::Application#initialize requires a "\
        "name to be specified",
        caller
      end


      @device      = opts[:model]
      @model       = Model.get_model(opts[:model], opts[:orientation])
      @name        = opts[:name].to_s
    end

    def num_quadrants
      @model.num_quadrants
    end

    def orientation
      @model.orientation
    end

    def update_display(*frames)
      if frames.size != num_quadrants then
        raise ArgumentError,
        "Incorrect number of frames sent for update. "\
        "Expected #{num_quadrants}, got #{frames.size}.",
        caller
      end

      frame_update = FrameUpdate.new(self, frames)
      @frame_buffer.push(frame_update) if @frame_buffer
    end

    def inspect
      "Application, name: #{@name}, model: #{@model.name}, orientation: #{@orientation}".color(:yellow)
    end
  end
end

