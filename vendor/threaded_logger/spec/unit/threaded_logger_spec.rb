require File.dirname(__FILE__) + '/../spec_helper.rb'

describe ThreadedLogger do
  before(:each) do
    ThreadedLogger.reset
  end

  it "should exist" do
    ThreadedLogger.should_not be_nil
  end

  it "should start out with no logs" do
    ThreadedLogger.logs.size.should == 0
  end

  describe "#create_log" do
    it "should be possible to create a new log with a symbol" do
      ThreadedLogger.create_log(:benny)
      ThreadedLogger.logs.size.should == 1
    end

    it "should be possible to create a new log with a string" do
      ThreadedLogger.create_log("toddy")
      ThreadedLogger.logs.size.should == 1
    end

    it "should be possible to create multiple logs" do
      ThreadedLogger.create_log(:boris)
      ThreadedLogger.create_log(:beans)
      logs = ThreadedLogger.logs
      logs.size.should == 2
      logs.each{|log| log.class.should == ThreadedLogger}
    end
  end

  describe "#get_log" do
    it "should return nil if the log hasn't been created" do
      ThreadedLogger.get_log(:unknown).should be_nil
    end

    it "should be possible to get a log with a symbol" do
      ThreadedLogger.create_log(:bimhuis)
      ThreadedLogger.get_log(:bimhuis).should_not be_nil
    end

    it "should be possible to get a log with a string" do
      ThreadedLogger.create_log(:bimhuis)
      ThreadedLogger.get_log("bimhuis").should_not be_nil
    end
  end

  describe "with a new log" do
    before(:each) do
      ThreadedLogger.create_log(:ted)
      @log = ThreadedLogger.get_log(:ted)
    end

    it "should have the right name" do
      @log.name.should == "ted"
    end

    it "should start out with no messages inside it" do
      @log.length.should == 0
    end

    it "should be possible to send it a message" do
      @log.log "hello there"
      @log.length.should == 1
    end

    it "should be possible to sent it multiple messages" do
      @log.log "hello"
      @log.log "there"
      @log.log "world"
      @log.length.should == 3
    end

    it "should use STDOUT as the default outstream" do
      @log.outstream.should == STDOUT
    end

    it "should be possible to initialize one with an outstream" do
      outstream = ""
      @log.outstream = outstream
      @log.outstream.should == outstream
    end

    describe "with starting and stopping and with a given outstream" do
      before(:each) do
        @outstream = ""
        @log.outstream = @outstream
        @log.start
      end

      after(:each) do
        @log.stop
      end

      it "should start with the outstream being an empty string" do
        @outstream.should == ""
      end

      it "should have the correct outstream" do
        @log.outstream.should == @outstream
      end

      it "should place the messages to the outstream" do
        time = Time.now

        @log.log "hi"
        @log.log "there"
        @log.log "how"
        @log.log "are"
        @log.log "you?"

        while(@log.num_messages_logged < 5) do
          if Time.now - time > 0.5
            raise "Taking too long to place messages onto the @log outstream, only managed to receive #{@log.num_messages} messages"
          end
        end

        @outstream.should == "hi\nthere\nhow\nare\nyou?\n"
      end

      it "should be possible to place 10000 messages to the outstream from 1000 different threads" do
        time = Time.now

        1000.times do |i|
          thread_name = "thread #{i}"

          Thread.new do
            10.times do |j|
              message = "#{thread_name}: message #{j}"
              @log.log message
            end
          end
        end

        while(@log.num_messages_logged < 10000) do
          if Time.now - time > 3
            raise "Taking too long to place messages onto the @log outstream, only managed to receive #{@log.num_messages_logged} messages"
          end
        end

        @outstream.split("\n").size.should == 10000
      end
    end
  end
end
