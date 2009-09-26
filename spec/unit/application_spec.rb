require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe AppConnector do
  it "should resolve to the correct constant from this context" do
    AppConnector.should == Polynome::AppConnector
  end

  describe "#initialize" do
it "should be possible to initialise an application with a model and an orientation" do
    lambda{AppConnector.new(:model => '256', :cable_orientation => :top)}.should_not raise_error
  end

    it "should raise an ArgumentError if an unknown cable orientation is specified" do
      lambda{AppConnector.new(:model => "256", :cable_orientation => "wireless (dream on)")}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no model is specified" do
      lambda{Monome.new()}.should raise_error(ArgumentError)
    end


    it "should default to a cable orientation of top if one isn't supplied" do
      AppConnector.new(:model => "256").cable_orientation.should == :top
    end
  end
end
