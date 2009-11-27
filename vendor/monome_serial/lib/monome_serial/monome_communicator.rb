module MonomeSerial
  class MonomeCommunicator
    #It's important to note that the vanilla behaviour of these methods
    #doesn't match that of the OSC protocol specification as implemented
    #by the original OS X MonomeSerial application. In order to match
    #these behviours it is necessary to map the calls appropriately for
    #the given device and rotation. This class just provides raw access
    #to the serial protocol and serves it unadultered.

    attr_reader :communicator, :serial, :protocol

    def initialize(tty_path, protocol="series")
      raise ArgumentError, "Unexpected protocol type: #{protocol}. Expected 40h or series" unless protocol == "40h" || protocol == "series"

      @protocol = protocol

      #try to pull out serial for the monome represented by
      #this tty_path
      match  = tty_path.match /m(\d+h?)-(\d+)/
      @serial = match ? match[2] : "Serial Unknown"

      #get communicator (will return a DummyCommunicator if the path
      #isn't correct)
      @communicator = SerialCommunicator.get_communicator(tty_path)

      #include the correct binary patterns
      if @protocol == "40h"
        extend SerialCommunicator::BinaryPatterns::Fourtyh
      else
        extend SerialCommunicator::BinaryPatterns::Series
      end
    end

    def illuminate_lamp(x,y)
      @communicator.write([led_on_pattern,  x_y_coord_pattern(x,y)])
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

    def illuminate_column(col, pattern)
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
      reversed_patterns = patterns.map{|pat| pat.reverse}
      @communicator.write([frame_pattern(quadrant), *reversed_patterns])
    end

    def brightness=(intensity)
      @communicator.write([brightness_pattern(intensity)])
    end

    def read
      @communicator.read
    end
  end
end
