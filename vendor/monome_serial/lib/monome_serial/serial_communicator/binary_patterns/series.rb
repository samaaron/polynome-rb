module MonomeSerial
  module SerialCommunicator
    module BinaryPatterns
      module Series
        #       monmome serial protocol series 256/128/64
        #       brian crabtree - tehn@monome.org
        #
        #       revision: 070903
        #
        #
        #       from device:
        #
        #       message id:     (0) keydown
        #       bytes:          2
        #       format:         iiii.... xxxxyyyy
        #                               i (message id) = 0
        #                               x (x value) = 0-15 (four bits)
        #                               y (y value) = 0-15 (four bits)
        #       decode:         id match: byte 0 >> 4 == 0
        #                               x: byte 1 >> 4
        #                               y: byte 1 & 0x0f
        #
        #
        #       message id:     (1) keyup
        #       bytes:          2
        #       format:         iiii.... xxxxyyyy
        #                               i (message id) = 1
        #                               x (x value) = 0-15 (four bits)
        #                               y (y value) = 0-15 (four bits)
        #       decode:         id match: byte 0 >> 4 == 1
        #                               x: byte 1 >> 4
        #                               y: byte 1 & 0x0f
        #
        #
        #
        #       to device:
        #
        #       message id:     (2) led_on
        #       bytes:          2
        #       format:         iiii.... xxxxyyyy
        #                               i (message id) = 2
        #                               x (x value) = 0-15 (four bits)
        #                               y (y value) = 0-15 (four bits)
        #       encode:         byte 0 = (id) << 4 = 32
        #                               byte 1 = (x << 4) | y
        #
        #
        #       message id:     (3) led_off
        #       bytes:          2
        #       format:         iiii.... xxxxyyyy
        #                               i (message id) = 3
        #                               x (x value) = 0-15 (four bits)
        #                               y (y value) = 0-15 (four bits)
        #       encode:         byte 0 = (id) << 4 = 48
        #                               byte 1 = (x << 4) | y
        #
        #
        #       message id:     (4) led_row1
        #       bytes:          2
        #       format:         iiiiyyyy aaaaaaaa
        #                               i (message id) = 4
        #                               y (row to update) = 0-15 (4 bits)
        #                               a (row data 0-7) = 0-255 (8 bits)
        #       encode:         byte 0 = ((id) << 4) | y = 64 + y
        #                               byte 1 = a
        #
        #
        #       message id:     (5) led_col1
        #       bytes:          2
        #       format:         iiiixxxx aaaaaaaa
        #                               i (message id) = 5
        #                               x (col to update) = 0-15 (4 bits)
        #                               a (col data 0-7) = 0-255 (8 bits)
        #       encode:         byte 0 = ((id) << 4) | x = 80 + x
        #                               byte 1 = a
        #
        #
        #       message id:     (6) led_row2
        #       bytes:          3
        #       format:         iiiiyyyy aaaaaaaa bbbbbbbb
        #                               i (message id) = 6
        #                               y (row to update) = 0-15 (4 bits)
        #                               a (row data 0-7) = 0-255 (8 bits)
        #                               b (row data 8-15) = 0-255 (8 bits)
        #       encode:         byte 0 = ((id) << 4) | y = 96 + y
        #                               byte 1 = a
        #                               byte 2 = b
        #
        #
        #       message id:     (7) led_col2
        #       bytes:          3
        #       format:         iiiixxxx aaaaaaaa bbbbbbbb
        #                               i (message id) = 7
        #                               x (col to update) = 0-15 (4 bits)
        #                               a (col data 0-7) = 0-255 (8 bits)
        #                               b (col data 8-15) = 0-255 (8 bits)
        #       encode:         byte 0 = ((id) << 4) | x = 112 + x
        #                               byte 1 = a
        #                               byte 2 = b
        #
        #
        #       message id:     (8) led_frame
        #       bytes:          9
        #       format:         iiii..qq aaaaaaaa bbbbbbbb cccccccc dddddddd eeeeeeee ffffffff gggggggg hhhhhhhh
        #                               i (message id) = 8
        #                               q (quadrant) = 0-3 (2 bits)
        #                               a-h (row data 0-7, per row) = 0-255 (8 bits)
        #       encode:         byte 0 = ((id) << 4) | q = 128 + q
        #                               byte 1,2,3,4,5,6,7,8 = a,b,c,d,e,f,g,h
        #       note:           quadrants are from top left to bottom right, as shown:
        #                               0 1
        #                               2 3
        #
        #       message id:     (9) clear
        #       bytes:          1
        #       format:         iiii---c
        #                               i (message id) = 9
        #                               c (clear state) = 0-1 (1 bit)
        #       encode:         byte 0 = ((id) << 4) | c = 144 + c
        #       note:           clear state of 0 turns off all leds.
        #                               clear state of 1 turns on all leds.
        #
        #
        #       message id:     (10) intensity
        #       bytes:          1
        #       format:         iiiibbbb
        #                               i (message id) = 10
        #                               b (brightness) = 0-15 (4 bits)
        #       encode:         byte 0 = ((id) << 4) | b = 160 + b
        #
        #
        #       message id:     (11) mode
        #       bytes:          1
        #       format:         iiii..mm
        #                               i (message id) = 11
        #                               m (mode) = 0-3 (2 bits)
        #       encode:         byte 0 = ((id) << 4) | m = 176 + m
        #       note:           mode = 0 : normal
        #                               mode = 1 : test (all leds on)
        #                               mode = 2 : shutdown (all leds off)
        #
        #
        #
        #
        #
        #       auxiliary ports
        #
        #       to device:
        #
        #       message id:     (12) activate port
        #       bytes:          1
        #       format:         iiiiaaaa
        #                               i (message id) = 12
        #                               a (which port) = 0-15 (four bits)
        #       encode:         byte 0 = (id) << 4 = 192 + a
        #
        #
        #       message id:     (13) deactivate port
        #       bytes:          1
        #       format:         iiiiaaaa
        #                               i (message id) = 13
        #                               a (which port) = 0-15 (four bits)
        #       encode:         byte 0 = (id) << 4 = 208 + a
        #
        #
        #       from device:
        #
        #       message id:     (14) auxiliary input
        #       bytes:          2
        #       format:         iiiiaaaa dddddddd
        #                               i (message id) = 14
        #                               a (port number) = 0-15 (four bits)
        #                               d (data) = 0-255 (eight bits)
        #       decode:         id match: byte 0 >> 4 == 1
        #                               a: byte 0 & 0x0f
        #                               d: byte 1
        INT_TO_BIN_STRING = {
          0  => "0000",
          1  => "0001",
          2  => "0010",
          3  => "0011",
          4  => "0100",
          5  => "0101",
          6  => "0110",
          7  => "0111",
          8  => "1000",
          9  => "1001",
          10 => "1010",
          11 => "1011",
          12 => "1100",
          13 => "1101",
          14 => "1110",
          15 => "1111"
        }

        X_Y_COORD_PATTERNS = (0..15).inject({}) do |hash, x|
          (0..15).each {|y| hash[[x,y]] = INT_TO_BIN_STRING[x] + INT_TO_BIN_STRING[y]}
          hash
        end

        EIGHT_LIGHT_ROW_PATTTERNS = (0..15).inject({}) do |hash, row|
          hash[row] = "0100" + INT_TO_BIN_STRING[row]
          hash
        end

        SIXTEEN_LIGHT_ROW_PATTERNS = (0..15).inject({}) do |hash, row|
          hash[row] = "0110" + INT_TO_BIN_STRING[row]
          hash
        end


        EIGHT_LIGHT_COL_PATTERNS = (0..15).inject({}) do |hash, row|
          hash[row] = "0101" + INT_TO_BIN_STRING[row]
          hash
        end

        SIXTEEN_LIGHT_COL_PATTERNS = (0..15).inject({}) do |hash, row|
          hash[row] = "0111" + INT_TO_BIN_STRING[row]
          hash
        end

        def led_on_pattern
          "00100000"
        end

        def led_off_pattern
          "00110000"
        end

        def x_y_coord_pattern(x, y)
          X_Y_COORD_PATTERNS[[x,y]]
        end

        def row_of_8_pattern(row)
          EIGHT_LIGHT_ROW_PATTTERNS[row]
        end

        def col_of_8_pattern(col)
          EIGHT_LIGHT_COL_PATTERNS[col]
        end

        def row_of_16_pattern(row)
          SIXTEEN_LIGHT_ROW_PATTERNS[row]
        end

        def col_of_16_pattern(col)
          SIXTEEN_LIGHT_COL_PATTERNS[col]
        end

        def clear_pattern
          "10010000"
        end

        def all_pattern
          "10010001"
        end

        def frame_pattern(quadrant)
          unless quadrant >= 1 && quadrant <= 4 then
            raise ArgumentError,
            "Expecting quadrant to be between 1 and 4 inclusively, got #{quadrant}"
          end

          quadrant_pattern = case quadrant
                             when 1 then "00"
                             when 2 then "01"
                             when 3 then "10"
                             when 4 then "11"
                             end
          "100000" + quadrant_pattern
        end


        def brightness_pattern(brightness)
          raise ArgumentError, "Expecting a brightness between 0 and 15 inclusively, got #{brightness}" unless brightness >= 0 && brightness <= 15

          "1010" + INT_TO_BIN_STRING[brightness]
        end

      end
    end
  end
end
