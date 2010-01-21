module Polynome
  module Model
    # Model to represent the 128 monome in landscape orientation
    #
    class OneTwentyEightLandscape < OneTwentyEightGeneric
      def initialize(rotation, cable_placement)
        if [:left, :right].include?(cable_placement) then
          raise ArgumentError,
          "Invalid cable placement for a 128 monome in landscape orientation. Was"\
          "especting one of (:top, :bottom), got #{cable_placement}",
          caller
        end

        super
        @width  = 16
        @height = 8
      end

      def rotate_frame!(frame)
        super

      end

      def button_quadrant(x,y)
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
      end

      def orientation
        case rotation_offset
        when 0,2 then :landscape
        when 1,3 then :portrait
        end
      end

    end
  end
end

