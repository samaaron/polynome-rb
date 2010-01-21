module Polynome
  class Projection
    class QuadrantCountMismatchError       < StandardError ; end
    class QuadrantOrientationMismatchError < StandardError ; end

    VALID_ROTATIONS      = [0, 90, 180, 270]
    VALID_128_QUADRANTS  = {
      :portrait  => [[1,3],[2,4]],
      :landscape => [[1,2],[3,4]]
    }

    attr_reader :application, :rotation, :quadrants, :surface

    def initialize(surface, application, quadrants, opts={})
      opts.reverse_merge! :rotation => 0, :invert => false

      unless VALID_ROTATIONS.include?(opts[:rotation]) then
        raise ArgumentError,
        "Invalid rotation value. Expected one of "\
        "(#{VALID_ROTATIONS.to_sentence :last_word_connector => ' or '}), "\
        "got #{opts[:rotation]}",
        caller
      end
      unless quadrants.kind_of?(Quadrants) then
        raise ArgumentError,
        "Quadrants should be of kind Quadrants, not #{quadrants.class}",
        caller
      end

      if application.num_quadrants != quadrants.count then
        raise QuadrantCountMismatchError,
        "The number of quadrants you specified does not match "\
        "the capacity of the application you specified. "\
        "Expected #{application.num_quadrants}, got #{quadrants.count}",
        caller
      end

      @rotation       = opts[:rotation]
      @model          = application.model
      @model.rotation = @rotation
      @surface        = surface
      @application    = application
      @quadrants      = quadrants
      @options        = opts

      if application.device == "128" && !VALID_128_QUADRANTS[@model.orientation].include?(quadrants) then
        raise QuadrantOrientationMismatchError,
        "The quadrants you specified don't match the orientation of the device at the rotation you specified."
        caller
      end
    end

    def on_current_surface?
      @surface.current_surface?
    end

    def update_display(*frames)
      frames.each_with_index do |frame, index|
        apply_options!(frame)
        @model.rotate_frame!(frame)
        mapped_quadrant_id = @model.map_quadrant_id(@quadrants[index], true)
        @surface.light_quadrant(mapped_quadrant_id, frame)
      end
    end

    def inspect
      "#<PROJECTION application: #{application.name}, rotation: #{rotation}, quadrants: #{quadrants.inspect}>"
    end

    def process_frame_update(frame_update)
      update_display(*frame_update.frames)
    end

    private

    def apply_options!(frame)
      frame.invert! if @options[:invert]
    end

    def rotation_offset
      case @rotation
      when 0   then 0
      when 90  then 1
      when 180 then 2
      when 270 then 3
      end
    end
  end
end
