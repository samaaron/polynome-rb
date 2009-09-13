module MonomeSerial
  class Monome
    include SerialCommunicator::BinaryPatterns::Series
    attr_reader :communicator, :serial, :model
    def initialize(tty_path)
      #pull out the model and serial for the monome represented by
      #this tty_path
      match  = tty_path.match /m(\d+)-(\d+)/
      @model  = match[1]
      @transposer = Transposer.new(@model)
      @serial = match[2]

      @communicator = SerialCommunicator.get_communicator(tty_path)

      @serial = @communicator
    end

    def illuminate_lamp(x,y)
      @communicator.write([led_on_pattern,  x_y_coord_pattern(*@transposer.transpose_coords(x,y))])
    end

    def extinguish_lamp(x,y)
      @communicator.write([led_off_pattern, x_y_coord_pattern(*@transposer.transpose_coords(x,y))])
    end

    def illuminate_row(row, pattern)
      #it seems that the defaults for the original OS X MonomeSerial
      #OSC protocol illuminates columns when the row command is called
      case pattern.size
      when 8 then
        @communicator.write([col_of_8_pattern(@transposer.transpose_row(row)), @transposer.transpose_row_pattern(pattern)])
      when 16 then
        transposed_pattern = @transposer.transpose_row_pattern(pattern)
        @communicator.write([col_of_16_pattern(@transposer.transpose_row(row)), transposed_pattern[0..7], transposed_pattern[8..15]])
      else
        raise ArgumentError, "Incorrect length of pattern sent to MonomeSerial::Monome#illumninate_row. Expected 8 or 16, got #{pattern.size}"
      end
    end

    def illuminate_col(col, pattern)
      case pattern.size
        when 8 then
        @communicator.write([row_of_8_pattern(@transposer.transpose_col(col)), @transposer.transpose_col_pattern(pattern)])
      when 16 then
        @communicator.write([row_of_16_pattern(@transposer.transpose_col(col)), pattern[0..7], pattern[8..15]])
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
