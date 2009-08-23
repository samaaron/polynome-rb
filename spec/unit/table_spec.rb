require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Polynome::Table do
  it "should exist" do
    Polynome::Table.should_not be_nil
  end

  describe "initialisation" do
    it "should be possible to initialise with default values" do
      table = Polynome::Table.new
      table.should_not be_nil
      table.shutdown
    end

    it "should be possible to initialise again with default values" do
      table = Polynome::Table.new
      table.should_not be_nil
      table.shutdown
    end

    it "should be possible to specify the in port to use" do
      table = Polynome::Table.new(:in_port => 1234)
      table.in_port.should == 1234
      table.shutdown
    end

    it "should be possible to specify the out port to use" do
      table = Polynome::Table.new(:out_port => 5678)
      table.out_port.should == 5678
      table.shutdown
    end

    it "should be possible to specify the out host to use" do
      table = Polynome::Table.new(:out_host => 'beans.com')
      table.out_host.should == 'beans.com'
      table.shutdown
    end
  end

  describe "Adding a Virtual Monome" do
    before(:each) do
      @table     = Polynome::Table.new(:in_port => 4443)
      @receiver = Tosca::Receiver.new(5544)
      @sender   = Tosca::Sender.new(4433)
      @table.boot
    end

    after(:each) do
      @table.shutdown
    end

    it "should know that no vms are currently in a new table" do
      @table.num_vms.should == 0
    end

    it "should know that there is one vm after adding one" do
      vm = Polynome::VirtualMonome.new
      @table.add_vm(vm)
      @table.num_vms.should == 1
      vm.power_down
    end
  end

  describe "Test mode" do
    before(:each) do
      @sender   = Tosca::Sender.new(4433)
      @receiver = Tosca::Receiver.new(5544)
      @table     = Polynome::Table.new(:in_port => 4433)
      @table.boot
    end

    after(:each) do
      @table.shutdown
    end

    it "should be possible to register with the Table to receive all output" do
      message = @receiver.wait_for(1) do
        @sender.send('/polynome/test/register_output', 'test_client', 'localhost', 5544)
      end

      message.should == [["/polynome/test/register_output/ack", []]]
    end

    it "should resend incoming messages via test channel" do
      messages = @receiver.wait_for(5) do
        @sender.send('/polynome/test/register_output', 'test_client', 'localhost', 5544)
        @sender.send('/polynome/test/dummy')
        @sender.send('/polynome/test/dummy')
        @sender.send('/polynome/test/dummy')
        @sender.send('/polynome/test/dummy')
      end

      messages.should == [
                          ["/polynome/test/register_output/ack", []],
                          ["/polynome/test/received/test_client/polynome/test/dummy", []],
                          ["/polynome/test/received/test_client/polynome/test/dummy", []],
                          ["/polynome/test/received/test_client/polynome/test/dummy", []],
                          ["/polynome/test/received/test_client/polynome/test/dummy", []]
                         ]
    end

    it "should resend outgoing messages via test channel"
  end

end
