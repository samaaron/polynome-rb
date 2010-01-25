require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe LightBank do
  it "should exist" do
    LightBank.should_not be_nil
  end
end

describe LightBank, ", initialised with defaults" do
  it "should start off with one layer" do
    LightBank.new.num_layers.should == 1
  end
end
