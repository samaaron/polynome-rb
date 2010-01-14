module Polynome
  module Model
    #Model to represent the 64 monome
    class SixtyFour < GenericModel
      def initialize(rotation, cable_placement)
        set_rotation_and_cable_placement!(rotation, cable_placement)

        @name                      = "64"
        @width                     = 8
        @height                    = 8
        @protocol                  = "series"
        @num_quadrants             = 1
        @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      end

      def button_quadrant(x,y)
        if (y <= 8 && x <= 8 && x >= 1 && y >= 1)
          1
        else
          raise InvalidButtonCoord, "Sorry, the coordinates you specified: "\
          "(#{x}, #{y}) are invalid for the 64. Expected x coord in the "\
          "range (1..8) and y coord in the range (1..8).",
          caller
        end
      end
    end
  end
end
