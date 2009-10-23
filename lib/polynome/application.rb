module Polynome
  class Application
    class NameInUseError < Exception ; end
    class UnknownName    < Exception ; end

    def self.name_already_registered?(name)
      find_application_by_name(name)  if @applications
    end

    def self.register_application(application)
      @applications ||= []
      @applications << application
    end

    def self.reset_registered_applications!
      @applications = []
    end

    def self.[](name)
      app = find_application_by_name(name)
      unless app then
        raise UnknownName,
        "Unable to find an application with the name #{name}"
      end
      return app
    end

    def self.find_application_by_name(name)
      application = @applications.find{|app| app.name == name} if @applications
    end

    attr_reader :orientation, :name, :model
    attr_accessor :projection

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

      @model        = Model.get_model(opts[:model].to_s, opts[:orientation])
      @orientation = opts[:orientation]
      @interface   = Interface.new(model)
      @name        = opts[:name]
      self.class.register_application(self)
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

      projection.update_display(*frames) if projection
    end
  end
end
