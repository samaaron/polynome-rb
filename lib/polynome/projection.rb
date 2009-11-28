module Polynome
  class Projection
    class QuadrantCountMismatchError       < StandardError ; end
    class RotationOrientationMismatchError < StandardError ; end

    VALID_ROTATIONS           = [0, 90, 180, 270]
    INVALID_128_APP_ROTATIONS = [90, 270]

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


      if application.interface_type == "128" && INVALID_128_APP_ROTATIONS.include?(opts[:rotation]) then
        raise RotationOrientationMismatchError,
        "The rotation you have specified (#{opts[:rotation]}) is invalid for the 128 "\
        "as it is not square like the 64 or 256 monomes. You should specify one "\
        "of the following: #{(VALID_ROTATIONS - INVALID_128_APP_ROTATIONS).inspect}.",
        caller
      end
      @surface     = surface
      @application = application
      @quadrants   = quadrants
      @model       = application.model
      @rotation    = opts[:rotation]
      @options     = opts
    end

    def on_current_surface?
      @surface.current_surface?
    end

    def update_display(*frames)
      frames.each_with_index do |frame, index|
        apply_options!(frame)
        @model.rotate_frame(frame, @quadrants, @rotation)
        mapped_quadrant_id = @model.map_quadrant(@quadrants[index], @quadrants, rotation_offset)
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
