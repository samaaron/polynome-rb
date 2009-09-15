require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe MonomeCommunicator do
  it "should exist" do
    MonomeCommunicator.should_not be_nil
  end

  describe "with a default MonomeCommunicator" do
    before(:each) do
      @mcom = MonomeCommunicator.new
    end

    it "should be possible to add a new MonomeSerial connection"

  end
end
