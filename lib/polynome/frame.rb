module Polynome
  class Frame
    def initialize(binary_string)
      raise ArgumentError, "Expected 64 bits to be used, found #{binary_string.length}" unless binary_string.length == 64
      @bit_array = convert_binary_string_to_bit_array(binary_string)
    end

    def read
      @bit_array
    end

    def invert!
      @bit_array = @bit_array.map do |row|
        inverted = ""
        row.each_char{|c| inverted << (c == "1" ? "0" : "1")}
        inverted
      end
      self
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
