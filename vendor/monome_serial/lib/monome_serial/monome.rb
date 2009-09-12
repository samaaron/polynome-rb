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
  end
end
