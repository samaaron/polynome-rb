module Polynome
  class OSCSender
    include Loggable

    attr_reader :log_history
    def initialize(port, opts={})
      opts.reverse_merge!(
                          :host          => "localhost",
                          :logger        => nil,
                          :debug         => false,
                          :debug_message => ""
                         )

      @host        = opts[:host]
      @logger      = opts[:logger]
      @port        = port
      @log_history = ""
      @debug       = opts[:debug]
      @name = "#{opts[:debug_message]} OSCSender"
      log "debug mode on, set to send on port #{@port}"

    end

    def send(message_path, *args)
      socket  = OSC::UDPSocket.new
      message = OSC::Message.new(message_path, nil, *args)
      socket.send message, 0, @host, @port

      log "sent: #{message_path}, #{args.inspect} to port #{@port} on #{@host}"
    end

  end
end
