module Polynome
  class OSCSender
    def initialize(port, host="localhost")
      @host = host
      @port = port
    end

    def send(message_path, *args)
      socket  = OSC::UDPSocket.new
      message = OSC::Message.new(message_path, nil, *args)
      socket.send message, 0, @host, @port
    end
  end
end
