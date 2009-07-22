module Polynome
  module TestHelpers
    class Receiver
      attr_reader :port
      def initialize(port)
        @port = port
      end

      def wait_for(num_messages_to_receive=1)
        raise "Polynome::TestHelpers::Receiver#receive should wait for at least one message, you asked it to wait for #{num_messages_to_receive}" if num_messages_to_receive < 1
        
        listener = OSC::UDPServer.new
        listener.bind("localhost", @port)
        messages = []
        
        listener.add_method nil, nil do |message|
          messages << [message.address, message.args]
        end
        
        t = Thread.new do
          listener.serve
        end

        yield
        
        while(num_messages_to_receive > messages.size)
        end
        
        
        listener.close
        messages
      end
    end
  end
end
