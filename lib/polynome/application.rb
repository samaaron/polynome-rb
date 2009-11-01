module Polynome
  class Application
    attr_reader :orientation, :name, :model
    attr_accessor :rack

    def initialize(opts = {})
      opts.reverse_merge! :orientation => :landscape

      unless opts[:model] then
        raise ArgumentError,
          "Polynome::Application#initialize requires a " +
          "model to be specified"
      end

      unless opts[:name] then
        raise ArgumentError,
          "Polynome::Application#initialize requires a " +
          "name to be specified"
      end

      @model        = Model.get_model(opts[:model].to_s, opts[:orientation])
      @orientation = opts[:orientation]
      @interface   = Interface.new(model)
      @name        = opts[:name]
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
        "Expected #{num_quadrants}, got #{frames.size}."
      end
      frame_update = FrameUpdate.new(self, frames)
      rack.update_frame(frame_update) if @rack
    end
  end
end
