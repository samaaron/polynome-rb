module Polynome
  class Application
    attr_reader :orientation, :name, :model
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

      @model       = Model.get_model(opts[:model].to_s, opts[:orientation])
      @orientation = opts[:orientation]
      @interface   = Interface.new(model)
      @name        = opts[:name].to_s
    end

    def num_quadrants
      @interface.num_quadrants
    end

    def interface_type
      @interface.model_type
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

