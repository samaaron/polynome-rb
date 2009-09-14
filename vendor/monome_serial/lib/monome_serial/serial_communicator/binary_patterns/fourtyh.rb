module MonomeSerial
  module SerialCommunicator
    module BinaryPatterns
      module Fourtyh
        #please implement me
        #http://docs.monome.org/doku.php?id=tech:protocol:40h

        def led_on_pattern
          raise NotImplementedError, "please implement me"
        end

        def led_off_pattern
          raise NotImplementedError, "please implement me"
        end

        def x_y_coord_pattern(x,y)
          raise NotImplementedError, "please implement me"
        end

        def row_of_8_pattern(row)
          raise NotImplementedError, "please implement me"
        end

        def row_of_16_pattern(row)
          raise NotImplementedError, "please implement me"
        end

        def col_of_8_pattern(col)
          raise NotImplementedError, "please implement me"
        end

        def col_of_16_pattern(col)
          raise NotImplementedError, "please implement me"
        end

        def clear_pattern
          raise NotImplementedError, "please implement me"
        end

        def all_pattern
          raise NotImplementedError, "please implement me"
        end

        def frame_pattern(quadrant)
          raise NotImplementedError, "please implement me"
        end

        def brightness_pattern(brightness)
          raise NotImplementedError, "please implement me"
        end
      end
    end
  end
end
