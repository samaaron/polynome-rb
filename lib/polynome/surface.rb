module Polynome
  class Surface

    class UnknownSurfaceError < StandardError
    end

    class DuplicateSurfaceError < StandardError
    end

    class SurfaceSizeError < StandardError
    end

    attr_reader :num_quadrants, :name

    def initialize(name, num_quadrants)
      raise ArgumentError, "Unexpected quadrant count. Expected one of the set {#{Quadrants.list_valid_quadrant_counts}}. Got #{num_quadrants}" unless Quadrants.valid_quadrant_count?(num_quadrants)

      @name = name.to_s
      @num_quadrants = num_quadrants
    end

    def update_display(index, frame)
      raise ArgumentError, "Unexpected frame index. Expected one of the set #{(1..@num_frames).to_a.join(', ')}, got #{num_frames}" if index < 1 || index > @num_frames

      #TODO: implement me!
      #if this is the current surface, update monome's display
      #if it isn't, then just store the frame locally
    end

    def fetch_frame_buffer
      @frame_queue.pop
    end

    def register_application(application, opts={})
      raise ArgumentError, "You must specify which quadrant(s) this application wishes to use on this surface" unless opts[:quadrants]
      raise ArgumentError, "You must specify the cable orientation for this application on this surface" unless opts[:cable_orientation]

      quadrants = Quadrants.new(opts[:quadrants])

      raise SurfaceSizeError, "The number of quadrants you specified exceeds the capacity of this surface. Maximum number of quadrants supported: #{num_quadrants}, got #{quadrants.count}" if quadrants.count > num_quadrants

    end
  end
end
