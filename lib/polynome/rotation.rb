module Polynome
  class Rotation
    VALID_CABLE_PLACEMENTS = [:top, :bottom, :left, :right]

    def self.valid_cable_placement?(side)
      VALID_CABLE_PLACEMENTS.include?(side)
    end

    def self.list_possible_cable_placements
      VALID_CABLE_PLACEMENTS.to_sentence(:last_word_connector => ' or ')
    end

    attr_reader :rotation

    def initialize(rotation = 0, cable_placement = :top, device_rotation_offset = 0)
      unless self.class.valid_cable_placement?(cable_placement) then
        raise ArgumentError,
        "Unknown cable location: #{cable_placement}, "\
        "expected #{self.class.list_possible_cable_placements}",
        caller
      end

      @rotation = (cable_placement_rotation(cable_placement) + rotation) % 4
    end

    def cable_placement_rotation(cable_placement)
      case cable_placement
      when :top    then 0
      when :right  then 3
      when :bottom then 2
      when :left   then 1
      else  raise ArgumentError, "Unknown cable placement. Expected #{VALID_CABLE_PLACEMENTS.inspect}, got #{cable_placement}", caller
      end
    end
  end
end
