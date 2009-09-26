module Polynome
  class AppConnector
    attr_reader :cable_orientation

    def initialize(opts = {})
      opts.reverse_merge! :cable_orientation => :top

      raise ArgumentError, "Polynome::Application#initialize requires a model to be specified"    unless opts[:model]
      raise ArgumentError, "Unknown cable orientation: #{opts[:cable_orientation]}, expected #{Model.list_possible_orientations}" unless Model.valid_orientation?(opts[:cable_orientation])

      model             = Model.get_model(opts[:model])
      @cable_orientation = opts[:cable_orientation]
      @interface         = Interface.new(model)
    end
  end
end
