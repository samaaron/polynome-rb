require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Polynome::TestHelpers, "Sender and Receiver" do
  describe "Sender" do
    it "should exist" do
      Polynome::TestHelpers::Sender.should_not be_nil
    end

    describe "on initialisation" do
      it "should be possible to supply a host and port number" do
        sender = Polynome::TestHelpers::Sender.new(88888, "localhost")
        sender.host.should == "localhost"
        sender.port.should == 88888
      end

      it "should default to the host 'localhost'" do
        sender = Polynome::TestHelpers::Sender.new(88888)
        sender.host.should == "localhost"
      end
    end
  end

  describe "Receiver" do
    it "should exist" do
      Polynome::TestHelpers::Sender.should_not be_nil
    end

    describe "on initialisation" do
      it "should be possible to supply a port to listen on" do
        receiver = Polynome::TestHelpers::Receiver.new(99999)
        receiver.port.should == 99999
      end
    end

    describe "receive" do
      it "should raise an exception if it is asked to receive fewer than one message" do
        receiver = Polynome::TestHelpers::Receiver.new(99999)
        lambda{receiver.receive(0) }.should raise_error
        lambda{receiver.receive(-1)}.should raise_error
      end
    end
  end
  
  
  describe "sending and receiving" do
    before(:each) do
      @sender   = Polynome::TestHelpers::Sender.new(99999)
      @receiver = Polynome::TestHelpers::Receiver.new(99999)
    end

    it "should be possible to send and receive one message" do
      messages = @receiver.wait_for(1) do
        @sender.send("/foo/bar", 1)
      end
      messages.size.should == 1
      messages.should == [["/foo/bar", [1]]]
    end

    it "should be possible to send and receive two messages" do
      messages = @receiver.wait_for(2) do
        @sender.send("/foo/bar", 1)
        @sender.send("/quux/baz", 2)
      end
      messages.size.should == 2
      messages.should == [
                          ["/foo/bar",  [1]],
                          ["/quux/baz", [2]]
                         ]
    end

    it "should time out safely if an adequate number of messages aren't received" do
      lambda{@receiver.wait_for(1)}.should raise_error
    end
  end
end
