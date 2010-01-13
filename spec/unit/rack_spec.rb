require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Rack do
  before(:each) do
    @frame_buffer = SizedQueue.new(Defaults::FRAME_BUFFER_SIZE)
  end

  it "should resolve to the correct constant from this context" do
    Polynome::Rack.should == Rack
  end

  describe "#initialize" do
    it "should expect a frame buffer" do
      lambda{Rack.new(@frame_buffer)}.should_not raise_error
    end
  end

  describe "#<<" do
    it "should return self" do
      app256 = Application.new(:device => "256", :name => "beans")
      rack = Rack.new(@frame_buffer)
      (rack << app256).should == rack
    end

    it "should raise an error if the name specified is already in use" do
      adoo = Application.new(:device => "256", :name => "adoo")

      lambda{Rack.new(@frame_buffer) << adoo << adoo}.should raise_error(Rack::ApplicationNameInUseError)
    end
  end

  describe "#[]" do
    it "should be possible to fetch application instances using the class [] method" do
      adoo = Application.new(:device => '256', :name => "adoo_adoo")
      rack = Rack.new(@frame_buffer)
      rack << adoo
      rack["adoo_adoo"].should == adoo
    end

    it "should raise an application uknown error if no applications match the name given" do
      lambda{Rack.new(@frame_buffer)["unknown_application"]}.should raise_error(Rack::UnknownApplicationName)
    end
  end

end
