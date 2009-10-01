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
      lambda{AppConnector.new()}.should raise_error(ArgumentError)
    end


    it "should default to an orientation of landscape if one isn't supplied" do
      AppConnector.new(:model => "256").orientation.should == :landscape
    end
  end

  describe "#num_quadrants" do
    it "should return 1 for a 64 app" do
      AppConnector.new(:model => "64").num_quadrants.should == 1
    end

    it "should return 1 for a 40h app" do
      AppConnector.new(:model => "40h").num_quadrants.should == 1
    end

    it "should return 2 for a 128 app" do
      AppConnector.new(:model => "128").num_quadrants.should == 2
    end

    it "should return 4 for a 256 app" do
      AppConnector.new(:model => "256").num_quadrants.should == 4
    end
  end
end
