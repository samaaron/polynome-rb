module Polynome
  class OSCListener
    include Loggable

    class TimeOut            < StandardError ; end
    class WaitWhenNotRunning < StandardError ; end

    attr_reader :port, :prefix, :log_history

    def initialize(port, opts={})
      opts.reverse_merge!(
                          :prefix        => "",
                          :logger        => nil,
                          :debug         => false,
                          :debug_message => ""
                         )
      @port = port
      @logger = opts[:logger]
      @log_history = ""
      @name = "#{opts[:debug_message]} OSCListener"
      @debug = opts[:debug]
      @prefix = (opts[:prefix].start_with?('/') || opts[:prefix] == "") ? opts[:prefix] : "/#{opts[:prefix]}"
      @num_messages_received = 0
      @running = false
      open_port

      add_debug_logging_method if @debug
      log "#{@name} debug mode on, listening to port #{@port}"

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
      unless running?
        raise WaitWhenNotRunning,
        "You are attempting to wait for messages when the server isn't running",
        caller
      end

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
      return @running
    end

    def stop
      close_port
      @running = false
      return !@running
    end

    def running?
      @running
    end

    private

    def add_debug_logging_method
      add_method(:any, :any) do |message|
        log "received: #{message.address}, #{message.args.inspect}"
      end
    end

    def num_messages_received
      @listener.num_messages_received
    end

    def open_port
      unless @port_open
        log "trying to open port #{@port}"
        @listener = OSC::UDPServerWithCount.new
        @listener.bind("localhost", @port)
        @port_open = true
        log "opened port #{@port}"
      end
    end

    def close_port
      if @port_open
        log "trying to close port #{@port}"
        @listener.close
        @port_open = false
        log "closed port #{@port}"
      end
    end
  end
end
