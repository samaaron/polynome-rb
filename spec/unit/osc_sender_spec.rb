require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Polynome::OSCSender do
  it "should exist" do
    Polynome::OSCSender.should_not be_nil
  end

  it "should be possible to send messages with it" do
    receiver = Tosca::Receiver.new(5544)
    sender = Polynome::OSCSender.new(5544, :host => 'localhost')
    messages = receiver.wait_for(1) do
      sender.send('/hey/there', 1, 2, "three")
    end
    messages.should == [['/hey/there', [1,2,"three"]]]
  end
end
