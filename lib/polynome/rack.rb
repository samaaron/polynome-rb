module Polynome
  class Rack
    attr_reader :in_port, :out_port, :out_host
    def initialize(opts={})
      opts.reverse_merge!(
                          :in_port  => Polynome::BootOptions::INPORT,
                          :out_port => Polynome::BootOptions::OUTPORT,
                          :out_host => Polynome::BootOptions::OUTHOST
                          )
      
      @in_port  = opts[:in_port]
      @out_port = opts[:out_port]
      @out_host = opts[:out_host]
      
      @listener = OSCListener.new(@in_port, prefix="/polynome")
      @listener.add_method("/test/register_output", :any) do |message|
        port = message.args[1]
        host = message.args[0]
        register_test_output(port, host)
      end
      
      @sender = OSCSender.new(@out_port, @out_host)
    end

    def boot
      @listener.start
    end

    def shutdown
      @listener.stop
      @listener.close
    end

    def register_test_output(port, host)
      @test_sender = OSCSender.new(port, host)
      @test_sender.send('/polynome/test/register_output/ack')
    end
  end
end
