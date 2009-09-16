module Polynome
  class MonomeModel
    def self.get_model(model)
      case model
      when "40h" then return FourtyH.new
      when "64"  then return SixtyFour.new
      when "128" then return OneTwentyEight.new
      when "256" then return TwoFiftySix.new
      else raise ArgumentError, "Uknown monome model type: #{model}"
      end
    end
  end

  class FourtyH < MonomeModel
    def width
      8
    end

    def height
      8
    end

    def protocol
      "40h"
    end
  end

  class SixtyFour < MonomeModel
    def width
      8
    end

    def height
      8
    end

    def protocol
      "series"
    end
  end

  class OneTwentyEight < MonomeModel
    def width
      16
    end

    def height
      8
    end

    def protocol
      "series"
    end
  end

  class TwoFiftySix < MonomeModel
    def width
      16
    end

    def height
      16
    end

    def protocol
      "series"
    end
  end
end
