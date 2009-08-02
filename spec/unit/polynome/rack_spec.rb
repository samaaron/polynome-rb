require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Polynome::Rack do
  it "should exist" do
    Polynome::Rack.should_not be_nil
  end

  describe "initialisation" do
    it "should be possible to initialise with default values" do
      rack = Polynome::Rack.new
      rack.should_not be_nil
      rack.shutdown
    end
    
    it "should be possible to initialise again with default values" do
      rack = Polynome::Rack.new
      rack.should_not be_nil
      rack.shutdown
    end
    
    it "should be possible to specify the in port to use" do
      rack = Polynome::Rack.new(:in_port => 1234)
      rack.in_port.should == 1234
      rack.shutdown
    end
 
    it "should be possible to specify the out port to use" do
      rack = Polynome::Rack.new(:out_port => 5678)
      rack.out_port.should == 5678
      rack.shutdown
    end
 
    it "should be possible to specify the out host to use" do
      rack = Polynome::Rack.new(:out_host => 'beans.com')
      rack.out_host.should == 'beans.com'
      rack.shutdown
    end
  end
end
