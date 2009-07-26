require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Polynome::OSCListener do
  it "should exist" do
    Polynome::OSCListener.should_not be_nil
  end

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
