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

    it "should start with no monomes registered" do
      @mcom.num_monomes.should == 0
    end

    describe "register_monome" do
      it "should be possible to add a new MonomeSerial connection" do
        @mcom.register_monome('/blah/foo')
      end

      it "should increase the number of monomes" do
        @mcom.register_monome('/blah/foo')
        @mcom.num_monomes.should == 1
      end
    end
  end
end
