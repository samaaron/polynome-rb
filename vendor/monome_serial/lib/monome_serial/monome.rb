module MonomeSerial
  class Monome
    include SerialCommunicator::BinaryPatterns::Series
    attr_reader :communicator
    def initialize(tty_path)
      @communicator = SerialCommunicator.get_communicator(tty_path)
    end

    def illuminate_lamp(x,y)
      @communicator.write([led_on_pattern, x_y_coord_pattern(x,y)])
    end

    def extinguish_lamp(x,y)
      @communicator.write([led_off_pattern, x_y_coord_pattern(x,y)])
    end

    def illuminate_row(row, pattern)
      case pattern.size
        when 8 then
        @communicator.write([row_of_8_pattern(row), pattern])
        when 16 then
        @communicator.write([row_of_16_pattern(row), pattern[0..7], pattern[8..15]])
      else
        raise ArgumentError, "Incorrect length of pattern sent to MonomeSerial::Monome#illumninate_row. Expected 8 or 16, got #{pattern.size}"
      end
    end

    def illuminate_col(col, pattern)
      case pattern.size
        when 8 then
        @communicator.write([col_of_8_pattern(col), pattern])
        when 16 then
        @communicator.write([col_of_16_pattern(col), pattern[0..7], pattern[8..15]])
      else
        raise ArgumentError, "Incorrect length of pattern sent to MonomeSerial::Monome#illumninate_col. Expected 8 or 16, got #{pattern.size}"
      end
    end

    def illuminate_all
      @communicator.write([all_pattern])
    end

    def extinguish_all
      @communicator.write([clear_pattern])
    end

    def illuminate_frame(quadrant, patterns)
      raise ArgumentError, "Incorrect number of patterns sent to MonomeSerial::Monome#illuminate_frame. Expected 8, got #{patterns.size}" unless patterns.size == 8

      @communicator.write([frame_pattern(quadrant), *patterns])
    end

    def brightness=(intensity)
      @communicator.write([brightness_pattern(intensity)])
    end
  end
end
