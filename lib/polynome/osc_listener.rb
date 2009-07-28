module Polynome
  class OSCListener
    class TimeOut < StandardError
    end

    class WaitWhenNotRunning < StandardError
    end

    attr_reader :port, :prefix
    
    def initialize(port, prefix="")
      @port = port
      @prefix = (prefix.start_with?('/') || prefix == "") ? prefix : "/#{prefix}"
      
      @listener = OSC::UDPServer.new
      @listener.bind("localhost", port)
      @num_messages_received = 0
      @listener.add_method(nil, nil) {@num_messages_received += 1}
      @running = false
    end

    def add_method(path, type_spec, &block)
      #allow more descriptive * and :any as well as nil
      #to indicate that it will listen to any port or typespec
      p  = (path      == '*' || path      == :any) ? nil : path
      ts = (type_spec == '*' || type_spec == :any) ? nil : type_spec

      #prepend / if necessary
      p = "/#{p}" if (p && !p.start_with?('/'))
      
      #apply prefix if necessary
      p = @prefix     if (@prefix && path.nil?)
      p = @prefix + p if (@prefix && p)
      @listener.add_method(p, ts, &block)
    end

    def wait_for(num_messages_to_wait_for)
      raise WaitWhenNotRunning, "You are attempting to wait for messages when the server isn't running" unless running?
      
      current_num_messages = @num_messages_received
      yield if block_given?
      
      time = Time.now
      while(@num_messages_received < current_num_messages + num_messages_to_wait_for)
        if Time.now - time > 2
          raise TimeOut, "Stopped waiting for messages that don't appear to be arriving...'"
        end
      end
    end

    def start
      @thread = Thread.new do
        @listener.serve
      end
      @running = true
    end

    def stop
      @listener.close
      @running = false
    end

    def running?
      @running
    end

    def close
      stop
    end
  end
end
