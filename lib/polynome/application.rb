module Polynome
  class Application
    class NameInUseError < Exception ; end

    def self.name_already_registered?(name)
      @registered_names ||= []
      @registered_names.include?(name)
    end

    def self.register_name(name)
      @registered_names ||= []
      @registered_names << name
    end

    def self.reset_registered_names!
      @registered_names = []
    end

    attr_reader :orientation

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

      if self.class.name_already_registered?(opts[:name]) then
        raise NameInUseError,
        "The name #{opts[:name]} is already in use by another " +
          "application. Please specify a unique name"
      end

      unless Model.valid_orientation?(opts[:orientation]) then
        raise ArgumentError,
          "Unknown orientation: #{opts[:orientation]}, " +
          "expected #{Model.list_possible_orientations}"
      end


      model        = Model.get_model(opts[:model].to_s)
      @orientation = opts[:orientation]
      @interface   = Interface.new(model)
      self.class.register_name(opts[:name])
    end

    def num_quadrants
      @interface.num_quadrants
    end

    def interface_type
      @interface.model_type
    end
  end
end
