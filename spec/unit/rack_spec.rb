require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Rack do
  it "should resolve to the correct constant from this context" do
    Polynome::Rack.should == Rack
  end

  describe "#<<" do
    it "should return self" do
      app256 = Application.new(:model => "256", :name => "beans")
      rack = Rack.new
      (rack << app256).should == rack
    end

    it "should raise an error if the name specified is already in use" do
      adoo = Application.new(:model => "256", :name => "adoo")

      lambda{Rack.new << adoo << adoo}.should raise_error(Rack::ApplicationNameInUseError)
    end
  end


  describe "#[]" do
    it "should be possible to fetch application instances using the class [] method" do
      adoo = Application.new(:model => '256', :name => "adoo_adoo")
      rack = Rack.new
      rack << adoo
      rack["adoo_adoo"].should == adoo
    end

    it "should raise an application uknown error if no applications match the name given" do
      lambda{Rack.new["unknown_application"]}.should raise_error(Rack::UnknownApplicationName)
    end
  end

end
