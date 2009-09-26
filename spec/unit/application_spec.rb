require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Application do
  it "should resolve to the correct constant from this context" do
    Application.should == Polynome::Application
  end
end
