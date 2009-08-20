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
      @num_messages_received = 0
      @running = false
      open_port
    end

    ## takes an OSC message pattern and block. The block will be
    ## executed (and passed the OSC message as a param) if the
    ## incoming OSC message matches the pattern.
    ##
    ## The pattern consists of two parts: the path and a
    ## type_spec:
    ##
    ## *  The path is a string of the form /foo/bar/baz
    ##
    ## *  The type spec is a string which should match
    ##    the regep /[ifsb]*/ and corresponds to the
    ##    message parameters:
    ##    - i: integer
    ##    - f: float
    ##    - s: string
    ##    - b: blob (byte array with size)
    ##
    ##    The length of the typespec should be identical to the
    ##    number of params. For example, if the typespec is iifsbs
    ##    there should be 6 params of types integer, integer, float,
    ##    string, blog and string respectively
    ##
    ## Both the path and typespec can also be set to * or :any to make
    ## them match ALL incoming OSC messages.
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
      
      current_num_messages = num_messages_received
      yield if block_given?
      
      time = Time.now
      while(num_messages_received < current_num_messages + num_messages_to_wait_for)
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
      close_port
      @running = false
    end

    def running?
      @running
    end

    private

    def num_messages_received
      @listener.num_messages_received
    end

    def open_port
      unless @port_open
        @listener = UDPServerWithCount.new
        @listener.bind("localhost", @port)
        @port_open = true
      end
    end

    def close_port
      if @port_open
        @listener.close
        @port_open = false
      end
    end
  end
end
