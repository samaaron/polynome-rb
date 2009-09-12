module MonomeSerial
  module SerialCommunicator
    class Communicator
      def write(strings)
        raise ArgumentError, "The collection of stringified bytes passed into SerialCommunicator#write needs to respond to #[] and #size" unless strings.respond_to?("[]") && strings.respond_to?("size")
      end

      def read
      end

      def real?
        raise "please implement me"
      end
    end
  end
end
