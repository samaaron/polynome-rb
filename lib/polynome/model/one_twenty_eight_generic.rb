module Polynome
  module Model
    # Model to represent the 128 monome
    #
    # The 128 is rectangular, and therefore it's orientation matters. It can either be placed
    # horizontally or vertically. Horizontal placement is landscape orientation, vertical placement
    # is portrait placement. This means that there is interesting interplay between the rotation requested
    # and the orientation.
    #
    class OneTwentyEightGeneric < GenericModel
      def initialize(rotation, cable_placement)
        set_rotation_and_cable_placement!(rotation, cable_placement)

        @name                      = "128-landscape"
        @protocol                  = "series"
        @num_quadrants             = 2
        @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      end

      def map_quadrant_id(quadrant_id, log=false)
        puts "trying to map id: #{quadrant_id}" if log
        if [1,2].include?(rotation_offset)
          swap_quadrant_ids(quadrant_id)
        else
          quadrant_id
        end
      end

      def rotation=(rotation)
        super
      end

      private

      def swap_quadrant_ids(quadrant_id)

       #unless default_quadrants.include? quadrant_id then
       #  raise ArgumentError,
       #  "Unexpected quadrant id. Expected one of "\
       #  "#{default_quadrants.inspect}, got #{quadrant_id}",
       #  caller
       #end

        index = [1,2].index(quadrant_id)

        3
      end
    end
  end
end
p
