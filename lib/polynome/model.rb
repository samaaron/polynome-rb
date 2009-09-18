module Polynome
  class Model
    attr_reader :width, :height, :protocol, :num_frames

    def self.get_model(model)
      case model
      when "40h" then return FourtyH.new
      when "64"  then return SixtyFour.new
      when "128" then return OneTwentyEight.new
      when "256" then return TwoFiftySix.new
      else raise ArgumentError, "Unknown monome model type: #{model}"
      end
    end
  end

  class FourtyH < Model
    def initialize
      @width      = 8
      @height     = 8
      @protocol   = "40h"
      @num_frames = 1
    end
  end

  class SixtyFour < Model
    def initialize
      @width      = 8
      @height     = 8
      @protocol   = "series"
      @num_frames = 1
    end
  end

  class OneTwentyEight < Model
    def initialize
      @width      = 16
      @height     = 8
      @protocol   = "series"
      @num_frames = 2
    end
  end

  class TwoFiftySix < Model
    def initialize
      @width      = 16
      @height     = 16
      @protocol   = "series"
      @num_frames = 4
    end
  end
end
