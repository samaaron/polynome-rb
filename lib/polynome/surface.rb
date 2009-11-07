module Polynome
  class Surface

    class UnknownSurfaceError   < StandardError ; end
    class DuplicateSurfaceError < StandardError ; end
    class SurfaceSizeError      < StandardError ; end
    class QuadrantInUseError    < StandardError ; end
    class UnknownAppError       < StandardError ; end

    attr_reader :num_quadrants, :name, :display

    def initialize(name, monome)
      @num_quadrants = monome.num_quadrants

      @name = name.to_s
      @monome = monome
      @projections = {}
      @allocated_quadrants = {}
    end

    def light_quadrant(quadrant_id, frame)
      if (quadrant_id < 1) || (quadrant_id > @num_quadrants) then
        raise ArgumentError,
          "Unexpected frame index. Expected one of the set " +
          "(#{(1..@num_quadrants).to_a.join(', ')}), got #{quadrant_id}"
      end
      @monome.light_quadrant(quadrant_id, frame)
    end

    def fetch_frame_buffer
      @frame_queue.pop
    end

    def register_application(application, opts={})
      opts.reverse_merge! :quadrant => 1 if num_quadrants == 1
      opts.reverse_merge! :rotation => 0
      opts[:quadrants] = [opts[:quadrant]] if opts[:quadrant]

      unless opts[:quadrants] then
        raise ArgumentError,
          "You must specify which quadrant(s) this application " +
          "wishes to use on this surface"
      end
      if opts[:quadrants].size > num_quadrants then
        raise SurfaceSizeError,
          "The number of quadrants you specified exceeds the "     +
          "capacity of this surface. Maximum number of quadrants " +
          "supported: #{num_quadrants}, got #{opts[:quadrants].size}"
      end

      quadrants = Quadrants.new(opts[:quadrants])
      register_quadrants(quadrants)
      projection = Projection.new(self, application, quadrants, opts)
      @projections[quadrants] = projection
      return projection
    end

    def registered_applications
      @projections.values.map{|projection| projection.application}
    end

    def remove_application(application_name)
      projection_to_remove =  find_projection_by_application_name(application_name)
      unless projection_to_remove then
        raise UnknownAppError,
        "The application #{application_name} is not registered " +
          "with this surface."
      end

      @projections.delete_if {|_, projection| projection.application.name == application_name}
      deregister_quadrants(projection_to_remove.quadrants)
    end

    def current_surface?
      self == @monome.carousel.current
    end

    def displays_application?(application)
      !!@projections.values.find{|projection| projection.application.name == application.name}
    end

    def process_frame_update(frame_update)
      if (current_surface? && displays_application?(frame_update.application))
        find_projection_by_application_name(frame_update.application.name).process_frame_update(frame_update)
      end
    end

    private

    def find_projection_by_application_name(name)
      @projections.values.find{|projection| projection.application.name == name}
    end

    def deregister_quadrants(quadrants)
      quadrants.ids.each {|id| @allocated_quadrants[id] = false}
    end

    def register_quadrants(quadrants)
      #check whether quadrants are available
      quadrants.ids.each do |id|
        if @allocated_quadrants[id] then
          raise QuadrantInUseError,
            "Sorry, this quadrant is already in use by another " +
            "application controller"
        end
      end

      #register quadrant
      quadrants.ids.each do |id|
        @allocated_quadrants[id] = true
      end
    end
  end
end
