module Polynome
  module Model
    class InvalidButtonCoord < Exception ; end
    class InvalidOrientation < Exception ; end

    # Factory method to retrieve a +Model+ instance for your particular device.
    #
    # @param [String, #to_s] device Name of device (40h|64|128|256)
    # @param [Symbol] cable_placement placement of the cable (top|right|left|right).
    # @param [Fixnum] rotation Rotation of the device (in 90 degree intervals): (0|1|2|3)
    #
    # @return [Model] One of +FourtyH+, +SixtyFour+, +OneTwentyEight+ or +TwoFiftySix+
    def self.get_model(device, cable_placement = :top, rotation = 0)
      case device.to_s
      when "40h" then return FourtyH.new(cable_placement, rotation)
      when "64"  then return SixtyFour.new(cable_placement, rotation)
      when "128" then return OneTwentyEight.new(cable_placement, rotation)
      when "256" then return TwoFiftySix.new(cable_placement, rotation)
      else raise ArgumentError, "Unknown monome device type: #{device}", caller
      end
    end
  end
end
