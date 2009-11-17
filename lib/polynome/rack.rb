module Polynome
  class Rack
    class UnknownApplicationName < Exception ; end
    class ApplicationNameInUseError < Exception ; end

    attr_reader :applications

    def initialize(frame_buffer)
      @frame_buffer = frame_buffer
      @applications = []
    end

    def name_already_registered?(name)
      find_application_by_name(name)
    end

    def <<(application)
      if name_already_registered?(application.name) then
        raise ApplicationNameInUseError,
        "The name #{application.name} is already in use by another " +
          "application. Please specify a unique name"
      end

      application.frame_buffer = @frame_buffer

      @applications << application
      self
    end

    def [](name)
      app = find_application_by_name(name)
      unless app then
        raise UnknownApplicationName,
        "Unable to find an application with the name #{name}"
      end
      return app
    end

    def find_application_by_name(name)
      application = @applications.find{|app| app.name == name.to_s }
    end

    def update_frame(frame_update)
      @frame_buffer.push(frame_update)
    end

    def inspect
      "Rack, #{@applications.count} applications: #{@applications.map(&:name).inspect}"
    end
  end
end
