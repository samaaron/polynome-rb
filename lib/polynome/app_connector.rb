module Polynome
  class AppConnector
    attr_reader :orientation

    def initialize(opts = {})
      opts.reverse_merge! :orientation => :landscape

      unless opts[:model] then
        raise ArgumentError,
          "Polynome::Application#initialize requires a " +
          "model to be specified"
      end

      unless Model.valid_orientation?(opts[:orientation]) then
        raise ArgumentError,
          "Unknown orientation: #{opts[:orientation]}, " +
          "expected #{Model.list_possible_orientations}"
      end

      model        = Model.get_model(opts[:model].to_s)
      @orientation = opts[:orientation]
      @interface   = Interface.new(model)
    end

    def num_quadrants
      @interface.num_quadrants
    end

    def interface_type
      @interface.model_type
    end
  end
end
