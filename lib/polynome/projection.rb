module Polynome
  class Projection
    class QuadrantCountMismatchError       < StandardError ; end
    class RotationOrientationMismatchError < StandardError ; end

    VALID_ROTATIONS           = [0, 90, 180, 270]
    INVALID_128_APP_ROTATIONS = [90, 270]

    attr_reader :application, :rotation, :quadrants, :surface

    def initialize(surface, application, rotation, quadrants)
      unless VALID_ROTATIONS.include?(rotation) then
        raise ArgumentError,
        "Invalid rotation #{rotation}, expected " +
          "#{VALID_ROTATIONS.to_sentence :last_word_connector => ' or'}."
      end
      unless quadrants.kind_of?(Quadrants) then
        raise ArgumentError,
        "Quadrants should be of kind Quadrants, not #{quadrants.class}"
      end
      if application.num_quadrants != quadrants.count then
        raise QuadrantCountMismatchError,
        "The number of quadrants you specified does not match " +
          "the capacity of the application you specified. "       +
          "Expected #{application.num_quadrants}, got #{quadrants.count}"
      end
      if application.interface_type == "128" && INVALID_128_APP_ROTATIONS.include?(rotation) then
        raise RotationOrientationMismatchError,
        "The rotation you have specified is invalid for this device " +
          "as it is not square like the 64 or 256."
      end

      @surface     = surface
      @application = application
      @rotation    = rotation
      @quadrants   = quadrants
    end

    def on_current_surface?
      @surface.current_surface?
    end

    def update_display(*frames)
      #need to iterate through each frame, translating it to the
      #appropriate quadrant (and also transforming it appropriately)
      #and finally sending it to the surface
      @surface.update_display(1, frames.first)
    end

    def inspect
      "#<PROJECTION application: #{application.name}, rotation: #{rotation}, quadrants: #{quadrants.inspect}>"
    end
  end
end
