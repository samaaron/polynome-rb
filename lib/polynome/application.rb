module Polynome
  # The representation of an application. An application is a representation of an external app which is communicated to via OSC messages.
  # Each application has a given type - which maps onto one of the available monome models (64, 128, 256).
  # Each application also has a unique name which is used to identify it.
  #
  # Applications communicate with Polynome through a frame buffer onto which it pushes frames to be displayed.


  class Application
    attr_reader   :name, :model, :device
    attr_accessor :frame_buffer

    def initialize(opts = {})

      unless opts[:device] then
        raise ArgumentError,
        "Polynome::Application#initialize requires a "\
        "device to be specified",
        caller
      end

      unless opts[:name] then
        raise ArgumentError,
        "Polynome::Application#initialize requires a "\
        "name to be specified",
        caller
      end

      @device = opts[:device]
      @model  = Model.get_model(opts[:device])
      @name   = opts[:name].to_s
    end

    def num_quadrants
      @model.num_quadrants
    end

    def orientation
      @model.orientation
    end

    def receive_button_event(action, x, y, log=false)
      if log
        puts "[APPLICATION] receiving #{action} x:#{x}, y:#{y}"
        puts ""
        puts "---"
        puts ""
      end

      case action
      when :keydown then button_pressed(x,y)
      when :keyup   then button_released(x,y)
      else raise "Unknown button event: #{action}"
      end
    end

    def button_pressed(x,y)
    end

    def button_released(x,y)
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
      "Application, name: #{@name}, model: #{@model.name}".color(:yellow)
    end
  end
end

