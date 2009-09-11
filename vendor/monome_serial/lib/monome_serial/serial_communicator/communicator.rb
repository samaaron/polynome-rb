module MonomeSerial
  module SerialCommunicator
    class Communicator
      def write(strings)
        raise ArgumentError, "The collection of stringified bytes passed into SerialCommunicator#write needs to respond to #[] and #size"
        raise ArgumentError, "SerialCommunicator#write only supports sending one, two or three bytes at a time. You tried to send #{strings.size} bytes." if strings.size > 3
      end

      def read
      end

      def real?
        raise "please implement me"
      end
    end
  end
end
