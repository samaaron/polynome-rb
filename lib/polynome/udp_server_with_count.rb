class UDPServerWithCount < OSC::UDPServer
  attr_reader :num_messages_received

  def initialize
    @num_messages_received = 0
    super
  end

  def serve
    loop do
      p, sender = recvfrom(MAX_MSG_SIZE)
      dispatch p
      @num_messages_received += 1
    end
  end
end
