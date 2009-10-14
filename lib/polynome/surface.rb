module Polynome
  class Surface

    class UnknownSurfaceError   < StandardError ; end
    class DuplicateSurfaceError < StandardError ; end
    class SurfaceSizeError      < StandardError ; end
    class QuadrantInUseError    < StandardError ; end
    class UnknownAppError       < StandardError ; end

    attr_reader :num_quadrants, :name

    def initialize(name, num_quadrants)
      raise ArgumentError, "Unexpected quadrant count. Expected one of the set {#{Quadrants.list_valid_quadrant_counts}}. Got #{num_quadrants}" unless Quadrants.valid_quadrant_count?(num_quadrants)

      @name = name.to_s
      @num_quadrants = num_quadrants
      @projections = {}
      @allocated_quadrants = {}
    end

    def update_display(index, frame)
      if (index < 1) || (index > @num_frames) then
        raise ArgumentError,
          "Unexpected frame index. Expected one of the set " +
          "#{(1..@num_frames).to_a.join(', ')}, got #{num_frames}"
      end

      #TODO: implement me!
      #if this is the current surface, update monome's display
      #if it isn't, then just store the frame locally
    end

    def fetch_frame_buffer
      @frame_queue.pop
    end

    def register_application(application, opts={})
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
      projection = Projection.new(application, opts[:rotation], quadrants)

      @projections[quadrants] = projection
    end

    def registered_applications
      @projections.values.map{|projection| projection.application}
    end

    def remove_application(application_name)
      num_registered_apps_before_removal = @projections.size
      removed = @projections.delete_if {|_, projection| projection.application.name == application_name}
      unless num_registered_apps_before_removal > @projections.size then
        raise UnknownAppError,
        "The application #{application_name} is not registered " +
          "with this surface."
      end
    end

    private

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
