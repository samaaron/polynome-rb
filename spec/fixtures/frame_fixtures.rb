module Polynome
  module FrameFixtures

    def self.all_lit_array
      [
       "11111111",
       "11111111",
       "11111111",
       "11111111",
       "11111111",
       "11111111",
       "11111111",
       "11111111"
      ]
    end

    def self.all_lit_string
      all_lit_array.join
    end

    def self.all_lit_frame
      Frame.new(all_lit_string)
    end

    def self.blank_array
      [
       "00000000",
       "00000000",
       "00000000",
       "00000000",
       "00000000",
       "00000000",
       "00000000",
       "00000000"
      ]
    end

    def self.blank_string
      blank_array.join
    end

    def self.blank_frame
      Frame.new(blank_string)
    end

    def self.bit_array64
      [
       "00000000",
       "11100010",
       "10000110",
       "10001010",
       "11101111",
       "10100010",
       "11100010",
       "00000000"
      ]
    end

    def self.bit_string64
      bit_array64.join
    end

    def self.frame64
      Frame.new(bit_string64)
    end

    def self.bit_array64_90
      [
       "01111110",
       "01010010",
       "01110010",
       "00000000",
       "00011000",
       "00010100",
       "01111110",
       "00010000"
      ]
    end

    def self.bit_string64_90
      bit_array64_90.join
    end

    def self.frame64_90
      Frame.new(bit_string64_90)
    end

    def self.bit_array64_180
      [
       "00000000",
       "01000111",
       "01000101",
       "11110111",
       "01010001",
       "01100001",
       "01000111",
       "00000000"
      ]
    end

    def self.bit_string64_180
      bit_array64_180.join
    end

    def self.frame64_180
      Frame.new(bit_string64_180)
    end


    def self.bit_array64_270
      [
       "00001000",
       "01111110",
       "00101000",
       "00011000",
       "00000000",
       "01001110",
       "01001010",
       "01111110"
      ]
    end

    def self.bit_string64_270
      bit_array64_270.join
    end

    def self.frame64_270
      Frame.new(bit_string64_270)
    end

    def self.bit_array128_1
      [
       "00000000",
       "00110011",
       "01010000",
       "00010000",
       "00010011",
       "00010010",
       "00010010",
       "01111011"
      ]
    end

    def self.bit_string128_1
      bit_array128_1.join
    end

    def self.frame128_1
      Frame.new(bit_string128_1)
    end

    def self.bit_array128_1_90
      [
       "00000000",
       "10000100",
       "10000010",
       "11111110",
       "10000000",
       "00000000",
       "11110010",
       "10010010"
      ]
    end

    def self.bit_string128_1_90
      bit_array128_1_90.join
    end

    def self.frame128_1_90
      Frame.new(bit_string128_1_90)
    end

    def self.bit_array128_1_180
      [
       "11011110",
       "01001000",
       "01001000",
       "11001000",
       "00001000",
       "00001010",
       "11001100",
       "00000000"
      ]
    end

    def self.bit_string128_1_180
      bit_array128_1_180.join
    end

    def self.frame128_1_180
      Frame.new(bit_string128_1_180)
    end

    def self.bit_array128_1_270
      [
       "01001001",
       "01001111",
       "00000000",
       "00000001",
       "01111111",
       "01000001",
       "00100001",
       "00000000"
      ]
    end

    def self.bit_string128_1_270
      bit_array128_1_270.join
    end

    def self.frame128_1_270
      Frame.new(bit_string128_1_270)
    end

    def self.bit_array128_2
      [
       "00000000",
       "11011110",
       "01010010",
       "01010010",
       "11011110",
       "00010010",
       "00010010",
       "11011110"
      ]
    end

    def self.bit_string128_2
      bit_array128_2.join
    end

    def self.frame128_2
      Frame.new(bit_string128_2)
    end

    def self.bit_array128_2_90
      [
       "10010010",
       "10011110",
       "00000000",
       "11111110",
       "10010010",
       "10010010",
       "11111110",
       "00000000"
      ]
    end

    def self.bit_string128_2_90
      bit_array128_2_90.join
    end

    def self.frame128_2_90
      Frame.new(bit_string128_2_90)
    end

    def self.bit_array128_2_180
      [
       "01111011",
       "01001000",
       "01001000",
       "01111011",
       "01001010",
       "01001010",
       "01111011",
       "00000000"
      ]
    end

    def self.bit_string128_2_180
      bit_array128_2_180.join
    end

    def self.frame128_2_180
      Frame.new(bit_string128_2_180)
    end

    def self.bit_array128_2_270
      [
       "00000000",
       "01111111",
       "01001001",
       "01001001",
       "01111111",
       "00000000",
       "01111001",
       "01001001"
      ]
    end

    def self.bit_string128_2_270
      bit_array128_2_270.join
    end

    def self.frame128_2_270
      Frame.new(bit_string128_2_270)
    end

    def self.bit_array256_1
      [
       "01010101",
       "10101010",
       "00000000",
       "00000000",
       "01111011",
       "00001010",
       "00001010",
       "01111011"
      ]
    end

    def self.bit_string256_1
      bit_array256_1.join
    end

    def self.frame256_1
      Frame.new(bit_string256_1)
    end

    def self.bit_array256_2
      [
       "01010101",
       "10101010",
       "00000000",
       "00000000",
       "11011110",
       "00010000",
       "00010000",
       "11010000"
      ]
    end

    def self.bit_string256_2
      bit_array256_2.join
    end

    def self.frame256_2
      Frame.new(bit_string256_2)
    end

    def self.bit_array256_3
      [
       "01000000",
       "01000000",
       "01000000",
       "01111011",
       "00000000",
       "00000000",
       "10101010",
       "01010101"
      ]
    end

    def self.bit_string256_3
      bit_array256_3.join
    end

    def self.frame256_3
      Frame.new(bit_string256_3)
    end

    def self.bit_array256_4
      [
       "01011110",
       "01010010",
       "01010010",
       "11011110",
       "00000000",
       "00000000",
       "10101010",
       "01010101"
      ]
    end

    def self.bit_string256_4
      bit_array256_4.join
    end

    def self.frame256_4
      Frame.new(bit_string256_4)
    end

    def self.bit_array256_1_90
      [
       "00000010",
       "10010001",
       "10010010",
       "10010001",
       "11110010",
       "00000001",
       "11110010",
       "10010001"
      ]
    end

    def self.bit_string256_1_90
      bit_array256_1_90.join
    end

    def self.frame256_1_90
      Frame.new(bit_string256_1_90)
    end

    def self.bit_array256_2_90
      [
       "10010010",
       "10010001",
       "00000010",
       "11110001",
       "00010010",
       "00010001",
       "00010010",
       "00000001"
      ]
    end

    def self.bit_string256_2_90
      bit_array256_2_90.join
    end

    def self.frame256_2_90
      Frame.new(bit_string256_2_90)
    end

    def self.bit_array256_3_90
      [
       "01000000",
       "10001111",
       "01001000",
       "10001000",
       "01001000",
       "10000000",
       "01001000",
       "10001000"
      ]
    end

    def self.bit_string256_3_90
      bit_array256_3_90.join
    end

    def self.frame256_3_90
      Frame.new(bit_string256_3_90)
    end

    def self.bit_array256_4_90
      [
       "01001000",
       "10001111",
       "01000000",
       "10001111",
       "01001001",
       "10001001",
       "01001111",
       "10000000"
      ]
    end

    def self.bit_string256_4_90
      bit_array256_4_90.join
    end

    def self.frame256_4_90
      Frame.new(bit_string256_4_90)
    end

    def self.bit_array256_1_180
      [
       "11011110",
       "01010000",
       "01010000",
       "11011110",
       "00000000",
       "00000000",
       "01010101",
       "10101010"
      ]
    end

    def self.bit_string256_1_180
      bit_array256_1_180.join
    end

    def self.frame256_1_180
      Frame.new(bit_string256_1_180)
    end

    def self.bit_array256_2_180
      [
       "00001011",
       "00001000",
       "00001000",
       "01111011",
       "00000000",
       "00000000",
       "01010101",
       "10101010"
      ]
    end

    def self.bit_string256_2_180
      bit_array256_2_180.join
    end

    def self.frame256_2_180
      Frame.new(bit_string256_2_180)
    end

    def self.bit_array256_3_180
      [
       "10101010",
       "01010101",
       "00000000",
       "00000000",
       "11011110",
       "00000010",
       "00000010",
       "00000010"
      ]
    end

    def self.bit_string256_3_180
      bit_array256_3_180.join
    end

    def self.frame256_3_180
      Frame.new(bit_string256_3_180)
    end

    def self.bit_array256_4_180
      [
       "10101010",
       "01010101",
       "00000000",
       "00000000",
       "01111011",
       "01001010",
       "01001010",
       "01111010"
      ]
    end

    def self.bit_string256_4_180
      bit_array256_4_180.join
    end

    def self.frame256_4_180
      Frame.new(bit_string256_4_180)
    end

    def self.bit_array256_1_270
      [
       "10001001",
       "01001111",
       "10000000",
       "01001111",
       "10001001",
       "01001001",
       "10001001",
       "01000000"
      ]
    end

    def self.bit_string256_1_270
      bit_array256_1_270.join
    end

    def self.frame256_1_270
      Frame.new(bit_string256_1_270)
    end

    def self.bit_array256_2_270
      [
       "10000000",
       "01001000",
       "10001000",
       "01001000",
       "10001111",
       "01000000",
       "10001001",
       "01001001"
      ]
    end

    def self.bit_string256_2_270
      bit_array256_2_270.join
    end

    def self.frame256_2_270
      Frame.new(bit_string256_2_270)
    end

    def self.bit_array256_3_270
      [
       "00010001",
       "00010010",
       "00000001",
       "00010010",
       "00010001",
       "00010010",
       "11110001",
       "00000010"
      ]
    end

    def self.bit_string256_3_270
      bit_array256_3_270.join
    end

    def self.frame256_3_270
      Frame.new(bit_string256_3_270)
    end

    def self.bit_array256_4_270
      [
       "00000001",
       "11110010",
       "10010001",
       "10010010",
       "11110001",
       "00000010",
       "11110001",
       "00010010"
      ]
    end

    def self.bit_string256_4_270
      bit_array256_4_270.join
    end

    def self.frame256_4_270
      Frame.new(bit_string256_4_270)
    end
  end
end
