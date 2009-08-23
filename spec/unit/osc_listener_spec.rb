require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Polynome::OSCListener do
  it "should exist" do
    Polynome::OSCListener.should_not be_nil
  end

  it "should be possible to initialise one with a specified port" do
    listener = Polynome::OSCListener.new(4422)
    listener.port.should == 4422
    listener.stop #necessary to release the port for other specs
  end

  it "should be possible to initialise one with a specified port and prefix" do
    listener = Polynome::OSCListener.new(4422, '/beans')
    listener.prefix.should == '/beans'
    listener.stop #necessary to release the port for other specs
  end

  it "should be possible to omit the initial forward slash in the prefix" do
    listener = Polynome::OSCListener.new(4422, 'beans')
    listener.prefix.should == '/beans'
    listener.stop #necessary to release the port for other specs
  end
end

describe Polynome::OSCListener, ", initialised listening to port 4422" do
  before(:each) do
    @listener = Polynome::OSCListener.new(4422)
    @listener.start
    @sender = Tosca::Sender.new(4422)
  end

  after(:each) do
    @listener.stop
  end

  it "should be possible to register methods with it" do
    messages = []
    @listener.add_method(:any, :any) { |message| messages << message}
    @listener.wait_for(1) do
      @sender.send('/hello/there/', 1,2,3)
    end
    messages.size.should == 1
  end
end

describe Polynome::OSCListener, ", listening to port 4422 with a predefined prefix" do
  before(:each) do
    @listener = Polynome::OSCListener.new(4422, "/beans")
    @listener.start
    @sender = Tosca::Sender.new(4422)
  end

  after(:each) do
    @listener.stop
  end

  it "should apply the prefix to any method you wish to listen for even if you specify any path" do
    messages = []
    @listener.add_method(:any, :any) { |message| messages << message}
    @listener.wait_for(1) do
      @sender.send('/beans/123', 1,2,3)
    end
    messages.size.should == 1
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
