module Polynome
  class Frame
    attr_reader :rotation
    def initialize(binary_string)
      raise ArgumentError, "Expected 64 bits to be used, found #{binary_string.length}" unless binary_string.length == 64
      @bit_array = convert_binary_string_to_bit_array(binary_string)
      @rotation = 0
    end

    def read
      @bit_array
    end

    def invert!
      @bit_array.map! do |row|
        row.each_char.to_a.map!{|i| i == "1" ? "0" : "1"}.join
      end

      self
    end

    def rotate(amount)
      unless [-270, -180, -90, 90, 180, 270].include? amount then
        raise ArgumentError,
        "Rotation amount not supported. Expected one of [-270, -180, -90, 90, 180, 270]. "\
        "Got #{amount}."
      end

      @rotation += amount
      @rotation = @rotation % 360
    end


    private
    def convert_binary_string_to_bit_array(binary_string)
      [
       binary_string[0..7],
       binary_string[8..15],
       binary_string[16..23],
       binary_string[24..31],
       binary_string[32..39],
       binary_string[40..47],
       binary_string[48..55],
       binary_string[56..63]
      ]
    end
  end
end
