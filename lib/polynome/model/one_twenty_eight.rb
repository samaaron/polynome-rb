module Polynome
  module Model
    # Model to represent the 128 monome
    #
    # The 128 is rectangular, and therefore it's orientation matters. It can either be placed
    # horizontally or vertically. Horizontal placement is landscape orientation, vertical placement
    # is portrait placement. This means that there is interesting interplay between the rotation requested
    # and the orientation.
    #
    # T
    class OneTwentyEight < GenericModel
      def initialize(rotation, cable_placement)
        set_rotation_and_cable_placement(rotation, cable_placement)
        validate_rotation!(rotation)

        @name                      = "128"
        @protocol                  = "series"
        @num_quadrants             = 2
        @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
        @rotation                  = rotation
        set_width_and_height!
      end

      def rotate_frame!(frame)
        super
        frame.rotate!(90) if [[1,3], [2,4]].include?(default_quadrants)
      end

      def map_quadrant_id(quadrant_id)
        if [1,2].include?(rotation)
          swap_quadrant_ids(quadrant_id)
        else
          quadrant_id
        end
      end

      def button_quadrant(x,y)
        if orientation == :landscape
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

      def rotation=(rotation)
        super
        set_width_and_height!
      end

      def orientation
        orientation = @rotation % 180 == 0 ? :landscape : :portrait
        return orientation
      end

      private

      def set_width_and_height!
        @width  = orientation == :landscape ? 16 : 8
        @height = orientation == :landscape ? 8  : 16
      end

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
