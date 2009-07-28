module Polynome
  class Rack
    def initialize(opts={})
      opts.reverse_merge!(:in_port => 4433)
      @listener = OSCListener.new(opts[:in_port], prefix="/polynome")
      @listener.add_method("/test/register_output", :any){|message| register_test_output(message.args[0], message.args[1])}
    end

    def boot
      @listener.start
    end

    def shutdown
      @listener.stop
    end

    def register_test_output(host, port)
      @test_sender = OSCSender.new(port, host)
      @test_sender.send('/polynome/test/register_output/ack')
    end
  end
end
