module Polynome
  class Table
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
      @listener.add_method(:any, :any){|message| send_to_test_channels(message)}

      @listener.add_method("/test/register_output", :any) do |message|
        app_name = message.args[0]
        port     = message.args[2]
        host     = message.args[1]
        register_test_output(app_name, port, host)
      end

      @sender = OSCSender.new(@out_port, @out_host)
      @test_channels = {}
      @vms = []
    end

    def boot
      @listener.start
    end

    def shutdown
      @listener.stop
    end

    def add_vm(vm)
      @vms << vm
    end

    def num_vms
      @vms.size
    end

    def register_test_output(app_name, port, host)
      test_sender = OSCSender.new(port, host)
      @test_channels[app_name] = test_sender
      test_sender.send('/polynome/test/register_output/ack')
    end

    def send_to_test_channels(message)
      @test_channels.each do |app_name, sender|
        sender.send "/polynome/test/received/#{app_name}#{message.address}", *message.args
      end
    end
  end
end