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
    def self.get_model(device, opts={})
      opts.reverse_merge!  :rotation => 0, :cable_placement => :none

      case device.to_s
      when "40h"  then return FourtyH.new(opts[:rotation],                 opts[:cable_placement])
      when "64"   then return SixtyFour.new(opts[:rotation],               opts[:cable_placement])
      when "256"  then return TwoFiftySix.new(opts[:rotation],             opts[:cable_placement])
      when "128l" then return OneTwentyEightLandscape.new(opts[:rotation], opts[:cable_placement])
      when "128p" then return OneTwentyEightPortrait.new(opts[:rotation],  opts[:cable_placement])
      when "128"  then return ([:left, :right].include?(opts[:cable_placement]) ? OneTwentyEightPortrait.new(opts[:rotation], opts[:cable_placement]) : OneTwentyEightLandscape.new(opts[:rotation], opts[:cable_placement]) )

      else raise ArgumentError, "Unknown monome device type: #{device}", caller
      end
    end
  end
end
