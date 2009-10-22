module Polynome
  class Model
    class InvalidOrientation < Exception ; end

    CABLE_ORIENTATIONS = [:top, :bottom, :left, :right]
    VALID_ORIENTATIONS = [:landscape]

    attr_reader :width, :height, :protocol, :num_quadrants, :name, :orientation

    def self.get_model(model, orientation = :landscape)
      case model
      when "40h" then return FourtyH.new(orientation)
      when "64"  then return SixtyFour.new(orientation)
      when "128" then return OneTwentyEight.new(orientation)
      when "256" then return TwoFiftySix.new(orientation)
      else raise ArgumentError, "Unknown monome model type: #{model}"
      end
    end

    def self.valid_cable_orientation?(orientation)
      CABLE_ORIENTATIONS.include?(orientation)
    end

    def self.list_possible_cable_orientations
      CABLE_ORIENTATIONS.to_sentence(:last_word_connector => ' or ')
    end

    def initialize(orientation)
      @orientation = orientation
    end

    def validate_orientation!(orientations = VALID_ORIENTATIONS)
      unless orientations.include?(@orientation) then
        raise InvalidOrientation,
        "Invalid orientation: #{@orientation}. Was expecting one of " +
          "#{orientations.inspect}"
      end
    end
  end

  class FourtyH < Model
    def initialize(orientation)
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
    def initialize(orientation)
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
    def initialize(orientation)
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
    def initialize(orientation)
      super
      validate_orientation!
      @name                      = "256"
      @width                     = 16
      @height                    = 16
      @protocol                  = "series"
      @num_quadrants             = 4
      @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      @device_orientation_offset = 0
    end
  end
end
