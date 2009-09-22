require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Interface do
  it "should resolve to the correct constant from this context" do
    Interface.should == Polynome::Interface
  end
end
