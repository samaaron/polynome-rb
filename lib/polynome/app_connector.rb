module Polynome
  class AppConnector
    attr_reader :orientation

    def initialize(opts = {})
      opts.reverse_merge! :orientation => :landscape

      raise ArgumentError, "Polynome::Application#initialize requires a model to be specified"    unless opts[:model]
      raise ArgumentError, "Unknown orientation: #{opts[:orientation]}, expected #{Model.list_possible_orientations}" unless Model.valid_orientation?(opts[:orientation])

      model             = Model.get_model(opts[:model])
      @orientation = opts[:orientation]
      @interface         = Interface.new(model)
    end
  end
end
