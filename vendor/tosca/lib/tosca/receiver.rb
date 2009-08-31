module Tosca
  class Receiver
    class TimeOut < StandardError
    end

    attr_reader :port, :log_history
    def initialize(port, opts={})
      opts.reverse_merge!(
                          :logger => nil,
                          :debug => false,
                          :debug_message => ""
                         )
      @port = port
      @stdout = $stdout
      @logger = opts[:logger]
      @log_history = ""
      @debug = opts[:debug]
      @name = "#{opts[:debug_message]} Tosca::Receiver"

      log "debug mode on. Listening to port #{@port}"
    end

    def wait_for(num_messages_to_receive=1, opts={})
      raise ArgumentError, "Tosca::Receiver#receive should wait for at least one message, you asked it to wait for #{num_messages_to_receive}" if num_messages_to_receive < 1

      opts.reverse_merge! :time_out_after => 0.5
      listener = OSC::UDPServerWithCount.new
      listener.bind("localhost", @port)
      messages = []

      listener.add_method nil, nil do |message|
        messages << [message.address, message.args]
      end

      if @debug
        listener.add_method(nil, nil) do |message|
          log "received: #{message.address}, #{message.args.inspect} from port #{@port}"
        end
      end

      t = Thread.new do
        listener.serve
      end

      yield if block_given?
      time = Time.now
      while(num_messages_to_receive > listener.num_messages_received)
        if Time.now - time > opts[:time_out_after]
          listener.close
          raise TimeOut, "Taking too long!"
        end
      end

      listener.close
      messages
    end


    private

    def log(message)
      if @debug
        @log_history << "#{@name} #{message}"
        @logger      << "#{@name} #{message}" if @logger
      end
    end
  end
end

