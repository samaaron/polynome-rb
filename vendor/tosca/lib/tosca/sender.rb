module Tosca
  class Sender
    attr_reader :host, :port
    def initialize(port, host="localhost")
      @host = host
      @port = port
    end

    def send(message_path, *args)
      socket  = OSC::UDPSocket.new
      message = OSC::Message.new(message_path, nil, *args)
      socket.send message, 0, @host, @port

      puts "#{@debug_mode} sent: #{message_path}, #{args.inspect} to port #{@port} on #{@host}" if @debug_mode
    end

    def debug_mode(message="TestHelpers::Sender")
      @debug_mode = message
    end
  end
end

