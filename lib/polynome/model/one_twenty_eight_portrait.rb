module Polynome
  module Model
    # Model to represent the 128 monome in portrait orientation
    #
    class OneTwentyEightPortrait < OneTwentyEightGeneric
      def initialize(rotation, cable_placement)
        if [:top, :bottom].include?(cable_placement) then
          raise ArgumentError,
          "Invalid cable placement for a 128 monome in portrait orientation. Was"\
          "expecting one of (:left, :right), got #{cable_placement}",
          caller
        end

        super
        @width  = 8
        @height = 16
      end

      def button_quadrant(x,y)
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

      def orientation
        case rotation_offset
        when 0,2 then :portrait
        when 1,3 then :landscape
        end
      end

    end
  end
end
