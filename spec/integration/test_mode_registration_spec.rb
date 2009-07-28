require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Test mode registration" do
  before(:each) do
    @sender   = Polynome::TestHelpers::Sender.new(4433)
    @receiver = Polynome::TestHelpers::Receiver.new(5544)
    @rack     = Polynome::Rack.new(:in_port => 4433)
    @rack.boot
  end

  after(:each) do
    @rack.shutdown
  end

  it "should be possible to register with the Rack to receive all output" do
    message = @receiver.wait_for(1) do
      @sender.send('/polynome/test/register_output', 'localhost', 5544)
    end

    message.should == [["/polynome/test/register_output/ack", []]]
  end
end
