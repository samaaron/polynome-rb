require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Polynome::ThreadedLogger do
  before(:each) do
    Polynome::ThreadedLogger.reset
  end

  it "should exist" do
    Polynome::ThreadedLogger.should_not be_nil
  end

  it "should start out with no messages inside it" do
    Polynome::ThreadedLogger.length.should == 0
  end

  it "should be possible to send it a message" do
    Polynome::ThreadedLogger.log "hello there"
    Polynome::ThreadedLogger.length.should == 1
  end

  it "should be possible to sent it multiple messages" do
    Polynome::ThreadedLogger.log "hello"
    Polynome::ThreadedLogger.log "there"
    Polynome::ThreadedLogger.log "world"
    Polynome::ThreadedLogger.length.should == 3
  end

  it "should use STDOUT as the default outstream" do
    Polynome::ThreadedLogger.outstream.should == STDOUT
  end

  it "should be possible to initialize one with an outstream" do
    outstream = ""
    Polynome::ThreadedLogger.outstream = outstream
    Polynome::ThreadedLogger.outstream.should == outstream
  end

  describe "with starting and stopping and with a given outstream" do
    before(:each) do
      @outstream = ""
      Polynome::ThreadedLogger.outstream = @outstream
      Polynome::ThreadedLogger.start
    end

    after(:each) do
      Polynome::ThreadedLogger.stop
    end


    it "should start with the outstream being an empty string" do
      @outstream.should == ""
    end

    it "should have the correct outstream" do
      Polynome::ThreadedLogger.outstream.should == @outstream
    end

    it "should place the messages to the outstream" do
      time = Time.now

      Polynome::ThreadedLogger.log "hi"
      Polynome::ThreadedLogger.log "there"
      Polynome::ThreadedLogger.log "how"
      Polynome::ThreadedLogger.log "are"
      Polynome::ThreadedLogger.log "you?"

      while(Polynome::ThreadedLogger.num_messages_logged < 5) do
        if Time.now - time > 0.5
          raise "Taking too long to place messages onto the ThreadedLogger outstream, only managed to receive #{Polynome::ThreadedLogger.num_messages} messages"
        end
      end

      @outstream.should == "hi\nthere\nhow\nare\nyou?\n"
    end
  end
end

