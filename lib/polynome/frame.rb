module Polynome
  class Frame
    attr_reader :rotation
    def initialize(binary_string)
      unless binary_string.length == 64 then
        raise ArgumentError,
        "Expected 64 bits to be used, found #{binary_string.length}",
        caller
      end
      @bit_array = convert_binary_string_to_bit_array(binary_string)
      @rotation = 0
    end

    def read
      case @rotation
      when 0   then @bit_array
      when 90  then rotate90
      when 180 then rotate180
      when 270 then rotate270
      else raise "Unexpected internal rotation. Expected one of [0, 90, 180, 270], found #{@rotation}"
      end
    end

    def invert!
      @bit_array.map! do |row|
        row.each_char.to_a.map!{|i| i == "1" ? "0" : "1"}.join
      end

      self
    end

    def rotate!(amount)
      unless [-270, -180, -90, 0, 90, 180, 270].include? amount then
        raise ArgumentError,
        "Rotation amount not supported. Expected one of [-270, -180, -90, 0, 90, 180, 270]. "\
        "Got #{amount}."
      end

      @rotation += amount
      @rotation = @rotation % 360
      self
    end

    def ==(other)
      other.read == read
    end

    def inspect
      "FRAME: #{read.inspect} (having been rotated by: #{rotation})"
    end

    private

    def rotate90
      result = []
      8.times{ result << []}

      @bit_array.each_with_index do |row, row_index|
        row.chars.to_a.each_with_index{|digit, index| result[index][7 - row_index] = digit}
      end
      result.map{|row| row.join}
    end

    def rotate180
      @bit_array.reverse.map{|row| row.reverse}
    end

    def rotate270
      result = []
      8.times{ result << []}

      @bit_array.each_with_index do |row, row_index|
        row.chars.to_a.each_with_index{|digit, index| result[7 - index][row_index] = digit}
      end
      result.map{|row| row.join}
    end

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
