module Polynome
  class Model
    CABLE_ORIENTATIONS = [:top, :bottom, :left, :right]
    ORIENTATIONS       = [:landscape, :portrait]

    attr_reader :width, :height, :protocol, :num_quadrants, :name

    def self.get_model(model)
      case model
      when "40h" then return FourtyH.new
      when "64"  then return SixtyFour.new
      when "128" then return OneTwentyEight.new
      when "256" then return TwoFiftySix.new
      else raise ArgumentError, "Unknown monome model type: #{model}"
      end
    end

    def self.valid_cable_orientation?(orientation)
      CABLE_ORIENTATIONS.include?(orientation)
    end

    def self.list_possible_cable_orientations
      CABLE_ORIENTATIONS.to_sentence(:last_word_connector => ' or ')
    end

    def self.valid_orientation?(orientation)
      ORIENTATIONS.include?(orientation)
    end

    def self.list_possible_orientations
      ORIENTATIONS.to_sentence(:last_word_connector => ' or')
    end

    def width_with_orientation(orientation)
      @width
    end

    def height_with_orientation(orientation)
      @height
    end
  end

  class FourtyH < Model
    def initialize
      @name          = "40h"
      @width         = 8
      @height        = 8
      @protocol      = "40h"
      @num_quadrants = 1
      @valid_quadrants = Quadrants.get_valid_quadrants(@num_quadrants)
    end
  end

  class SixtyFour < Model
    def initialize
      @name          = "64"
      @width         = 8
      @height        = 8
      @protocol      = "series"
      @num_quadrants = 1
      @valid_quadrants = Quadrants.get_valid_quadrants(@num_quadrants)
    end
  end

  class OneTwentyEight < Model
    def initialize
      @name          = "128"
      @width         = 16
      @height        = 8
      @protocol      = "series"
      @num_quadrants = 2
      @valid_quadrants = Quadrants.get_valid_quadrants(@num_quadrants)
    end

    def width_with_orientation(orientation)
      case orientation
      when :landscape then 16
      when :portrait  then 8
      else raise ArgumentError, "Unexpected orientation: #{orientation}, expected #{self.class.list_possible_orientations}"
      end
    end

    def height_with_orientation(orientation)
      case orientation
      when :landscape then 8
      when :portrait  then 16
      else raise ArgumentError, "Unexpected orientation: #{orientation}, expected #{self.class.list_possible_orientations}"
      end
    end
  end

  class TwoFiftySix < Model
    def initialize
      @name          = "256"
      @width         = 16
      @height        = 16
      @protocol      = "series"
      @num_quadrants = 4
      @valid_quadrants = Quadrants.get_valid_quadrants(@num_quadrants)
    end
  end
end
