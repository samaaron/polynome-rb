require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Rack do
  it "should exist" do
    Rack.should_not be_nil
  end

  describe "initialisation" do
    it "should be possible to initialise with default values" do
      rack = Rack.new
      rack.should_not be_nil
      rack.shutdown
    end

    it "should be possible to initialise again with default values" do
      rack = Rack.new
      rack.should_not be_nil
      rack.shutdown
    end

    it "should be possible to specify the in port to use" do
      rack = Rack.new(:in_port => 1234)
      rack.in_port.should == 1234
      rack.shutdown
    end

    it "should be possible to specify the out port to use" do
      rack = Rack.new(:out_port => 5678)
      rack.out_port.should == 5678
      rack.shutdown
    end

    it "should be possible to specify the out host to use" do
      rack = Rack.new(:out_host => 'beans.com')
      rack.out_host.should == 'beans.com'
      rack.shutdown
    end
  end

  describe "Adding a Monome" do
    before(:each) do
      @rack     = Rack.new(:in_port => 4443)
      @receiver = Tosca::Receiver.new(5544)
      @sender   = Tosca::Sender.new(4433)
      @rack.boot
    end

    after(:each) do
      @rack.shutdown
    end

    it "should know that no bankss are currently in a new rack" do
      @rack.num_vms.should == 0
    end

    it "should know that there is one bank after adding one" do
      bank = LightBank.new
      @rack.add_vm(bank)
      @rack.num_vms.should == 1
      bank.power_down
    end
  end

  describe "Test mode" do
    before(:each) do
      @sender   = Tosca::Sender.new(4433)
      @receiver = Tosca::Receiver.new(5544)
      @rack     = Rack.new(:in_port => 4433)
      @rack.boot
    end

    after(:each) do
      @rack.shutdown
    end

    it "should be possible to register with the Rack to receive all output" do
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
  end
end
