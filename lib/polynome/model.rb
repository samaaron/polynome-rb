module Polynome
  class Model
    class InvalidOrientation < Exception ; end

    VALID_CABLE_ORIENTATIONS   = [:top, :bottom, :left, :right]
    DEFAULT_VALID_ORIENTATIONS = [:landscape]

    attr_reader :width, :height, :protocol, :num_quadrants, :name, :orientation, :cable_orientation

    def self.get_model(model, orientation = :landscape, cable_orientation = :top)
      case model
      when "40h" then return FourtyH.new(orientation, cable_orientation)
      when "64"  then return SixtyFour.new(orientation, cable_orientation)
      when "128" then return OneTwentyEight.new(orientation, cable_orientation)
      when "256" then return TwoFiftySix.new(orientation, cable_orientation)
      else raise ArgumentError, "Unknown monome model type: #{model}"
      end
    end

    def self.valid_cable_orientation?(orientation)
      VALID_CABLE_ORIENTATIONS.include?(orientation)
    end

    def self.list_possible_cable_orientations
      VALID_CABLE_ORIENTATIONS.to_sentence(:last_word_connector => ' or ')
    end


    def initialize(orientation, cable_orientation)
      unless self.class.valid_cable_orientation?(cable_orientation) then
        raise ArgumentError,
        "Unknown cable orientation: #{cable_orientation}, "\
        "expected #{self.class.list_possible_cable_orientations}"
      end

      @cable_orientation = cable_orientation
      @orientation       = orientation
    end

    def map_quadrant_accordingly(quadrant_id)
      quadrant_id
    end

    def rotate_frame_accordingly(frame)
      offset = @device_orientation_offset + cable_orientation_offset
      offset.times{frame.rotate!(90)}
      frame
    end

    def cable_orientation_offset
      case @cable_orientation
      when :top    then 0
      when :right  then 3
      when :bottom then 2
      when :left   then 1
      else  raise ArgumentError, "Uknown cable orientation. Expected #{CABLE_ORIENTATIONS.inspect}, got #{orientation}"
      end
    end

    def validate_orientation!(orientations = DEFAULT_VALID_ORIENTATIONS)
      unless orientations.include?(@orientation) then
        raise InvalidOrientation,
        "Invalid orientation: #{@orientation}. Was expecting one of " +
          "#{orientations.inspect}"
      end
    end
  end

  class FourtyH < Model
    def initialize(orientation, cable_orientation)
      super
      validate_orientation!
      @name                      = "40h"
      @width                     = 8
      @height                    = 8
      @protocol                  = "40h"
      @num_quadrants             = 1
      @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      @device_orientation_offset = 0
    end
  end

  class SixtyFour < Model
    def initialize(orientation, cable_orientation)
      super
      validate_orientation!
      @name                      = "64"
      @width                     = 8
      @height                    = 8
      @protocol                  = "series"
      @num_quadrants             = 1
      @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      @device_orientation_offset = 0
    end
  end

  class OneTwentyEight < Model
    def initialize(orientation, cable_orientation)
      super
      validate_orientation!(DEFAULT_VALID_ORIENTATIONS + [:portrait])
      @name                      = "128"
      @protocol                  = "series"
      @num_quadrants             = 2
      @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      @device_orientation_offset = 0
      @width  = @orientation == :landscape ? 16 : 8
      @height = @orientation == :landscape ? 8  : 16
    end
  end

  class TwoFiftySix < Model
    def initialize(orientation, cable_orientation)
      super
      validate_orientation!
      @name                      = "256"
      @width                     = 16
      @height                    = 16
      @protocol                  = "series"
      @num_quadrants             = 4
      @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      @device_orientation_offset = 3
    end


    def map_quadrant_accordingly(quadrant_id)
      clockwise_quadrant_order = [1,2,4,3]
      index = clockwise_quadrant_order.index(quadrant_id)
      new_index = (index + @device_orientation_offset + cable_orientation_offset) % 4
      result = clockwise_quadrant_order[new_index]
      result
    end
  end
end
