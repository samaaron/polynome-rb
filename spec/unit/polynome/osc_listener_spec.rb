require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Polynome::OSCListener do
  it "should exist" do
    Polynome::OSCListener.should_not be_nil
  end

  it "should be possible to initialise one with a specified port" do
    listener = Polynome::OSCListener.new(4422)
    listener.port.should == 4422
    listener.close
  end

  it "should be possible to initialise one with a specified port and prefix" do
    listener = Polynome::OSCListener.new(4422, '/beans')
    listener.prefix.should == '/beans'
    listener.close
  end

  it "should be possible to omit the initial forward slash in the prefix" do
    listener = Polynome::OSCListener.new(4422, 'beans')
    listener.prefix.should == '/beans'
    listener.close
  end
end

describe Polynome::OSCListener, "initialised listening to port 4422" do
  before(:each) do
    @listener = Polynome::OSCListener.new(4422)
    @listener.start
    @sender = Polynome::TestHelpers::Sender.new(4422)
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

describe Polynome::OSCListener, "listening to port 4422 with a predefined prefix" do
  before(:each) do
    @listener = Polynome::OSCListener.new(4422, "/beans")
    @listener.start
    @sender = Polynome::TestHelpers::Sender.new(4422)
  end

  after(:each) do
    @listener.stop
  end
end
