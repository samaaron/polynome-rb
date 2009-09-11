module MonomeSerial
  module SerialCommunicator
    #Dummy class with no actual serial connection (so tests can execute
    #in other Ruby environments)
    class DummyCommunicator < Communicator
      def initialize
      end

      def read
        #super
        [:keydown, 1, 1]
      end

      def write(strings)
      end

      def real?
        false
      end
    end
  end
end
