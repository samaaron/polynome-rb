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

  describe ".strip_messages" do
    it "should return one message if there's one matching message" do
      messages = "[john, 10.27 27s] hey"
      ThreadedLogger.strip_messages(messages).should == "hey\n"
    end

    it "should return one message if there's one matching message with a trailing newline" do
      messages = "[john, 10.27 27s] hey\n"
      ThreadedLogger.strip_messages(messages).should == "hey\n"
    end

    it "should return multiple messages if there are multiple matching messages" do
      messages = "[john, 1.27 28s] hey\n[john, 1.27 29s] there"
      ThreadedLogger.strip_messages(messages).should == "hey\nthere\n"
    end

    it "should filter the messages correctly based on the second param" do
      messages = "[john, 1.27 28s] hey\n[ted, 1.27 29s] there\n[boris, 1.27 30s] how\n[ted, 1.30, 1s] are the cats\n"
      ThreadedLogger.strip_messages(messages, :ted).should == "there\nare the cats\n"
    end

    it "shouldn't filter any messages if no filter is passed" do
      messages = "[john, 1.27 28s] hey\n[ted, 1.27 29s] there\n[boris, 1.27 30s] how\n[ted, 1.30, 1s] are the cats\n"
      ThreadedLogger.strip_messages(messages).should == "hey\nthere\nhow\nare the cats\n"
    end
  end

  describe "#create_log" do
    it "should return the log just created" do
      log = ThreadedLogger.create_log(:eggs)
      log.should == ThreadedLogger.get_log(:eggs)
    end

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
      logs.each{|log| log.class.should == ThreadedLogger::TLogger}
    end

    it "should raise an error if the log already exists" do
      log = ThreadedLogger.create_log(:eggs)

      lambda{ThreadedLogger.create_log(:eggs)}.should raise_error(ThreadedLogger::CreateLogException)
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

  describe "with a new log with the default outstream" do
    before(:each) do
      @logger = ThreadedLogger.create_log(:ted)
    end

    it "should be possible to get the log" do
      ThreadedLogger.get_log(:ted).should == @logger
    end

    it "should have the right name" do
      @logger.name.should == "ted"
    end

    it "should start out with no messages inside it" do
      @logger.length.should == 0
    end

    it "should use STDOUT as the default outstream" do
      @logger.outstream.should == STDOUT
    end

    it "should be running after initilisation" do
      @logger.should be_running
    end

    it "should be possible to stop the logger" do
      @logger.stop
      @logger.should_not be_running
    end

    it "should return the logger on stop" do
      @logger.stop.should == @logger
    end
  end


  describe "with a new log with a given outstream" do
    before(:each) do
      @outstream = ""
      @logger = ThreadedLogger.create_log(:bill, @outstream)
    end

    after(:each) do
      @logger.stop
    end

    it "should be running" do
      @logger.should be_running
    end

    it "should start with the outstream being an empty string" do
      @outstream.should == ""
    end

    it "should have the correct outstream" do
      @logger.outstream.should == @outstream
    end

    it "should be possible to send it a message" do
      @logger.log "hello there"
      @logger.num_messages_received.should == 1
    end

    it "should be possible to sent it multiple messages" do
      @logger.log "hello"
      @logger.log "there"
      @logger.log "world"
      @logger.num_messages_received.should == 3
    end

    it "should place the correct 5 messages to the outstream" do
      time = Time.now

      @logger.log "hi"
      @logger.log "there"
      @logger.log "how"
      @logger.log "are"
      @logger.log "you?"

      while(@logger.num_messages_logged < 5) do
        if Time.now - time > 0.5
          raise "Taking too long to place messages onto the @logger outstream, only managed to receive #{@logger.num_messages} messages"
        end
      end

      messages = ThreadedLogger.strip_messages(@outstream, :bill)
      @logger.num_messages_logged.should == 5
      messages.should == "hi\nthere\nhow\nare\nyou?\n"
    end

    it "should be possible to log with the << message too" do
      time = Time.now

      @logger << "hi"
      @logger << "there"
      @logger << "how"
      @logger << "are"
      @logger << "you?"

      while(@logger.num_messages_logged < 5) do
        if Time.now - time > 0.5
          raise "Taking too long to place messages onto the @logger outstream, only managed to receive #{@logger.num_messages} messages"
        end
      end

      messages = ThreadedLogger.strip_messages(@outstream, :bill)
      @logger.num_messages_logged.should == 5
      messages.should == "hi\nthere\nhow\nare\nyou?\n"
    end

    it "should be possible to place 10000 messages to the outstream from 1000 different threads" do
      time = Time.now

      1000.times do |i|
        thread_name = "thread #{i}"

        Thread.new do
          10.times do |j|
            message = "#{thread_name}: message #{j}"
            @logger.log message
          end
        end
      end

      while(@logger.num_messages_logged < 10000) do
        if Time.now - time > 5
          raise "Taking too long to place messages onto the @log outstream, only managed to receive #{@logger.num_messages_logged} messages"
        end
      end

      @outstream.split("\n").size.should == 10000
    end
  end
end

describe "with multiple logs" do
  before(:each) do
    ThreadedLogger.create_log(:flower)
    @logger1 = ThreadedLogger.get_log(:flower)

    ThreadedLogger.create_log(:pot)
    @logger2 = ThreadedLogger.get_log(:pot)

    ThreadedLogger.create_log(:men)
    @logger3 = ThreadedLogger.get_log(:men)
  end
end

