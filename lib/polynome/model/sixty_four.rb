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
        @device_frame_rotation_offset    = 3
        @device_coord_rotation_offset    = 2
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

      def map_coords_based_on_rotation(x,y, quadrant_id)

        mapped_coords = case coord_rotation_offset
                        when 0 then [y, x]
                        when 1 then [y, 9-x]
                        when 2 then [9-x, 9-y]
                        when 3 then [9-y, x]
                        end

        mapped_coords.reverse! if @cable_placement == :none unless coord_rotation_offset == 0

        return mapped_coords
      end
    end
  end
end
