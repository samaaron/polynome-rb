module Polynome
  module Model
    #Model to represent the 128 monome
    class OneTwentyEight < GenericModel
      def initialize(orientation, cable_placement, rotation)
        set_rotation_and_cable_placement(rotation, cable_placement)
        validate_orientation(orientation)

        @orientation               = orientation
        @name                      = "128"
        @protocol                  = "series"
        @num_quadrants             = 2
        @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
        @width  = @orientation == :landscape ? 16 : 8
        @height = @orientation == :landscape ? 8  : 16
      end

      def valid_orientations
        DEFAULT_VALID_ORIENTATIONS + [:portrait]
      end

      def rotate_frame(frame, quadrants, rotation)
        super
        frame.rotate!(90) if [[1,3], [2,4]].include?(quadrants.to_a)
      end

      def map_quadrant_id(quadrant_id)
        if [1,2].include?(rotation)
          swap_quadrant_ids(quadrant_id)
        else
          quadrant_id
        end
      end

      def button_quadrant(x,y)
        if @orientation == :landscape
          if (y <= 8 && x <= 8 && x >= 1 && y >= 1)
            1 #left
          elsif (y <= 8 && x <= 16 && x >= 9 && y >= 1)
            2 #right
          else
            raise InvalidButtonCoord, "Sorry, the coordinates you specified: "\
            "(#{x}, #{y}) are invalid for the 128 in orientation landscape. "\
            "Expected x coord in the range (1..16) and y coord in the range (1..8).",
            caller
          end
        else #in portrait orientation
          if (y <= 8 && x <= 8 && x >= 1 && y >= 1)
            2 #bottom
          elsif (y <= 16 && x <= 8 && x >= 1 && y >= 9)
            1 #top
          else
            raise InvalidButtonCoord, "Sorry, the coordinates you specified: "\
            "(#{x}, #{y}) are invalid for the 128 in orientation portrait. "\
            "Expected x coord in the range (1..8) and y coord in the range (1..16).",
            caller
          end
        end
      end

      private

      def swap_quadrant_ids(quadrant_id)
        unless default_quadrants.include? quadrant_id then
          raise ArgumentError,
          "Unexpected quadrant id. Expected one of "\
          "#{default_quadrants.inspect}, got #{quadrant_id}",
          caller
        end

        index = default_quadrants.index(quadrant_id)
        default_quadrants[index - 1]
      end
    end
  end
end
