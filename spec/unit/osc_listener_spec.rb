require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe OSCListener do
  it "should exist" do
    OSCListener.should_not be_nil
  end

  it "should be possible to initialise one with a specified port" do
    listener = OSCListener.new(4422)
    listener.port.should == 4422
    listener.stop #necessary to release the port for other specs
  end

  it "should be possible to omit the initial forward slash in the prefix" do
    listener = OSCListener.new(4422, :prefix => 'beans')
    listener.prefix.should == '/beans'
    listener.stop #necessary to release the port for other specs
  end

  it "should remove the final forward slash" do
    listener = OSCListener.new(4422, :prefix => '/beans/')
    listener.prefix.should == '/beans'
    listener.stop #necessary to release the port for other specs
  end

  it "should default the prefix to ''" do
    listener = OSCListener.new(4422)
    listener.prefix.should == ''
    listener.stop #necessary to release the port for other specs
  end

  it "should not change the prefix when an empty string is used" do
    listener = OSCListener.new(4422, :prefix => '')
    listener.prefix.should == ''
    listener.stop #necessary to release the port for other specs
  end
end

describe OSCListener, ", initialised listening to port 4422" do
  before(:each) do
    @listener = OSCListener.new(4422)
    @listener.start
    @sender = OSCSender.new(4422)
  end

  after(:each) do
    @listener.stop
  end

  it "should be possible to register global methods with it (which will trigger on all received messages)" do
    messages = []
    @listener.add_global_method { |message| messages << message}
    @listener.wait_for(1) do
      @sender.send('/hello/there/', 1,2,3)
    end
    messages.size.should == 1
  end
end

describe OSCListener, ", listening to port 4422 with a predefined prefix" do
  before(:each) do
    @listener = OSCListener.new(4422, :prefix => "/beans")
    @listener.start
    @sender = OSCSender.new(4422)
  end

  after(:each) do
    @listener.stop
  end

  it "should apply the prefix to a method for which you specify a path" do
    messages = []
    @listener.add_method('boris/fred', :any) { |message| messages << message}
    @listener.wait_for(1) do
      @sender.send('/beans/boris/fred', 1,2,3)
    end
    messages.size.should == 1
  end

  it "should apply the prefix to a method for which you specify a path" do
    messages = []
    @listener.add_method('boris/fred', :any) { |message| messages << message}
    @listener.wait_for(1) do
      @sender.send('/egg/chips/brown_sauce', 1,2,3)
    end
    messages.should be_empty
  end
end
