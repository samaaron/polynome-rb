require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Display do
  it "should resolve to the correct constant from this context" do
    Display.should == Polynome::Display
  end
end
