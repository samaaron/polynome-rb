require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe OSCSender do
  it "should exist" do
    OSCSender.should_not be_nil
  end

  it "should be possible to send messages with it" do
    listener = OSCListener.new(5544)
    listener.start
    sender = OSCSender.new(5544)
    messages = listener.wait_for(1) do
      sender.send('/hey/there', 1, 2, "three")
    end
    messages.should == [['/hey/there', [1,2,"three"]]]
    listener.stop
  end
end
