require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Buttons do
  it "should resolve to the correct constant from this context" do
    Buttons.should == Polynome::Buttons
  end
end
