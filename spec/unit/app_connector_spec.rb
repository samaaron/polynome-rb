require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe AppConnector do
  it "should resolve to the correct constant from this context" do
    AppConnector.should == Polynome::AppConnector
  end

  describe "#initialize" do
it "should be possible to initialise an application with a model and an orientation" do
    lambda{AppConnector.new(:model => '256', :orientation => :landscape)}.should_not raise_error
  end

    it "should raise an ArgumentError if an unknown cable orientation is specified" do
      lambda{AppConnector.new(:model => "256", :orientation => :dreamscape)}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no model is specified" do
      lambda{Monome.new()}.should raise_error(ArgumentError)
    end


    it "should default to an orientation of landscape if one isn't supplied" do
      AppConnector.new(:model => "256").orientation.should == :landscape
    end
  end
end
