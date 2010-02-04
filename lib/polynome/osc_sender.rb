module Polynome
  class OSCSender
    include Loggable

    attr_reader :log_history

    def initialize(port, opts={})
      opts.reverse_merge!(
                          :host          => "localhost",
                          :debug         => Defaults.debug?,
                          :owner         => "Unknown Owner"
                         )

      @port        = port
      @name        = "#{opts[:owner]}-Sender"
      @logger      = opts[:logger] || Defaults.logger
      @host        = opts[:host]
      @owner       = opts[:owner]
      @debug       = opts[:debug]
      @prefix      = OSCPrefix.new(opts[:prefix])
      @logger_char = 'S'
      log 'READY', "Set to send on port #{@port} with prefix: #{@prefix.inspect}"
    end

    def send(message_path, *args)
      complete_path = OSCPrefix.new(@prefix, message_path)
      socket  = OSC::UDPSocket.new
      message = OSC::Message.new(complete_path, nil, *args)
      socket.send message, 0, @host, @port

      log 'MSG OUT', "#{complete_path}, #{args.inspect}, #{@host}:#{@port}"
    end

    def inspect
      "OSCSender, #{@host}:#{@port}, #{@prefix}, owner: #{@owner}"
    end
  end
end
