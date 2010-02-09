module Polynome
  class OSCListener
    include Loggable

    class TimeOut            < StandardError ; end
    class WaitWhenNotRunning < StandardError ; end

    attr_reader :port, :prefix, :log_history

    def initialize(port, opts={})
      opts.reverse_merge!(
                          :prefix        => "/",
                          :debug         => Defaults.debug?,
                          :owner         => "Unknown",
                          :host          => Defaults.outhost
                          )


      @port = port

      @host   = opts[:host]
      @owner  = opts[:owner]
      @logger = opts[:logger] || Defaults.logger
      @debug  = opts[:debug]
      @prefix = OSCPrefix.new(opts[:prefix])
      @name   = "#{opts[:owner]}-Listener"

      @logger_char           = 'L'
      @log_history           = ""
      @num_messages_received = 0
      @running               = false
      open_port

      add_debug_logging_method if @debug
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
      #to indicate that it will listen to any path or typespec
      ts = (type_spec == '*' || type_spec == :any) ? nil : type_spec
      full_path = OSCPrefix.new(@prefix, path)

      log 'REGISTER', "#{full_path}, #{ts.inspect}"
      @listener.add_method("#{full_path}", ts, &block)
    end

    #executes the block on *all* messages received
    def add_global_method(&block)
      @listener.add_method(nil, nil, &block)
    end

    def wait_for(num_messages_to_wait_for)
      unless running?
        raise WaitWhenNotRunning,
        "You are attempting to wait for messages when the server isn't running",
        caller
      end

      messages = []
      add_global_method { |mesg|  messages << [mesg.address, mesg.args] }

      current_num_messages = num_messages_received
      yield if block_given?

      time = Time.now
      while(num_messages_received < current_num_messages + num_messages_to_wait_for)
        if Time.now - time > 2
          raise TimeOut, "Stopped waiting for messages that don't appear to be arriving...'"
        end
      end
      messages
    end

    def start
      unless @running
        log 'READY', "Listening to #{@host}:#{@port} with prefix #{@prefix.inspect}"
        @thread = Thread.new do
          @listener.serve
        end
        @running = true
      end
      return @running
    end

    def stop
      if @running
        log 'SHUTDOWN', "Closing port"
        close_port
        @running = false
      end
      return @running
    end

    def running?
      @running
    end

    def inspect
      "OSCListener, #{@host}:#{@port}, prefix: #{@prefix}, owner: #{@owner}"
    end

    private

    def add_debug_logging_method
      add_global_method do |message|
        log 'MSG IN', "#{message.address}, #{message.args.inspect}"
      end
    end

    def num_messages_received
      @listener.num_messages_received
    end

    def open_port
      unless @port_open
        @listener = OSC::UDPServerWithCount.new
        @listener.bind(@host, @port)
        @port_open = true
        log 'INIT', "Opened port #{@port}"
      end
    end

    def close_port
      if @port_open
        @listener.close
        @port_open = false
        log 'SHUTDOWN', "Closed port #{@port}"
      end
    end


  end
end
