module Tosca
  class Receiver
    class TimeOut < StandardError
    end

    attr_reader :port, :log
    def initialize(port, log="")
      @port = port
      @stdout = $stdout
      @log = log
    end

    def wait_for(num_messages_to_receive=1)
      raise ArgumentError, "Tosca::Receiver#receive should wait for at least one message, you asked it to wait for #{num_messages_to_receive}" if num_messages_to_receive < 1

      listener = OSC::UDPServerWithCount.new
      listener.bind("localhost", @port)
      messages = []

      listener.add_method nil, nil do |message|
        messages << [message.address, message.args]
      end

      if @debug_mode
        puts "adding debug method"
        listener.add_method(nil, nil) do |message|
          @log << "#{@debug_mode} received: #{message_path}, #{args.inspect} from port #{@port}" if @debug_mode
        end
      end

      t = Thread.new do
        listener.serve
      end

      yield if block_given?
      time = Time.now
      while(num_messages_to_receive > listener.num_messages_received)
        if Time.now - time > 0.5
          listener.close
          raise TimeOut, "Taking too long!"
        end
      end

      listener.close
      messages
    end

    def debug_mode(message="Tosca::Receiver")
      @log << "#{message} debug mode on. Listening to port #{@port}"
      @debug_mode = message
    end
  end
end

