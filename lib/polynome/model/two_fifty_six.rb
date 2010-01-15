module Polynome
  module Model
    class TwoFiftySix < GenericModel
      def initialize(rotation, cable_placement)
        set_rotation_and_cable_placement!(rotation, cable_placement)

        @name                      = "256"
        @width                     = 16
        @height                    = 16
        @protocol                  = "series"
        @num_quadrants             = 4
        @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
        @device_rotation_offset    = 3
      end

      def map_quadrant_id(quadrant_id)
        #ignore quadrants

        #currently I have to handle button presses in clockwise rotation
        #and frame displays in anticlockwise rotation
        #this really suggests this code is due for a major
        #refactoring ;-)
        #TODO fix me please!x
        offset = -rotation

        clockwise_quadrant_order = [1,2,4,3]
        index = clockwise_quadrant_order.index(quadrant_id)
        new_index = (index + rotation) % 4
        result = clockwise_quadrant_order[new_index]
        result
      end

      def map_coords_based_on_rotation(x,y)
        case rotation_offset
        when 3 then x,y = y,x ; y = 16 - y ; x = 16 - x ; return x,y
        when 1 then  x += 1 ; y += 1 ; return y,x
        when 0 then y = 16 - y ; x += 1 ; return x,y
        when 2 then x = 16 - x ; y += 1 ; return x,y
        end
      end

      def button_quadrant(x,y)
        #return quadrant number as if cable is at top
        if (y <= 8 && x <= 8 && x >= 1 && y >= 1)
          3 # bottom left
        elsif (y <= 8 && x <= 16 && x >= 9 && y >= 1)
          4 # bottom right
        elsif (y <= 16 && x <= 16 && x >= 9 && y >= 9)
          2 # top right
        elsif (y <= 16 && x <= 8 && x >= 1 && y >= 9)
          1 # top left
        else
          raise InvalidButtonCoord, "Sorry, the coordinates you specified: "\
          "(#{x}, #{y}) are invalid for this device. Expected x coord in the "\
          "range (0..15) and y coord in the range (0..15).",
          caller
        end
      end
    end
  end
end
