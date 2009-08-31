module Tosca
  class Sender
    attr_reader :host, :port, :log_history
    def initialize(port, opts={})
      opts.reverse_merge!(
                          :host   => "localhost",
                          :logger => nil,
                          :debug  => false,
                          :debug_message => ""
                         )

      @port        = port
      @host        = opts[:host]
      @logger      = opts[:logger]
      @debug       = opts[:debug]
      @log_history = ""
      @name        = "#{opts[:debug_message]} Tosca::Sender"

      log "debug mode on. Set up to send messages to port #{@port}"
    end

    def send(message_path, *args)
      socket  = OSC::UDPSocket.new
      message = OSC::Message.new(message_path, nil, *args)
      socket.send message, 0, @host, @port

      log "sent: #{message_path}, #{args.inspect} to port #{@port} on #{@host}"
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

