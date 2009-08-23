require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Tosca, ", Sender and Receiver" do
  describe "Sender" do
    it "should exist" do
      Tosca::Sender.should_not be_nil
    end

    describe "on initialisation" do
      it "should be possible to supply a host and port number" do
        sender = Tosca::Sender.new(4422, "localhost")
        sender.host.should == "localhost"
        sender.port.should == 4422
      end

      it "should default to the host 'localhost'" do
        sender = Tosca::Sender.new(4422)
        sender.host.should == "localhost"
      end
    end
  end

  describe "Receiver" do
    it "should exist" do
      Tosca::Sender.should_not be_nil
    end

    describe "on initialisation" do
      it "should be possible to supply a port to listen on" do
        receiver = Tosca::Receiver.new(4422)
        receiver.port.should == 4422
      end
    end

    describe "wait_for" do
      it "should raise an exception if it is asked to receive fewer than one message" do
        receiver = Tosca::Receiver.new(4422)
        lambda{receiver.wait_for(0) }.should raise_error(ArgumentError)
        lambda{receiver.wait_for(-1)}.should raise_error(ArgumentError)
      end
    end
  end


  describe "sending and receiving" do
    before(:each) do
      @sender   = Tosca::Sender.new(4422)
      @receiver = Tosca::Receiver.new(4422)
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
        #warning, if you send floats you don't receive them
        #exactly the same. For example, sending 2.9 will receive
        #2.90000009536743
        @sender.send("/foo/bar", 1, 2, "bar")
        @sender.send("/quux/baz", 2, "beans")
      end
      messages.size.should == 2
      messages.should == [
                          ["/foo/bar",  [1, 2, "bar"]],
                          ["/quux/baz", [2, "beans"]]
                         ]
    end

    it "should time out safely if an adequate number of messages aren't received" do
      lambda{@receiver.wait_for(1)}.should raise_error(Tosca::Receiver::TimeOut)
    end
  end
end
