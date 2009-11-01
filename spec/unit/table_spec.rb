require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Table do
  it "should resolve to the correct constant from this context" do
    Polynome::Table.should == Table
  end

  describe "#rack" do
    it "should return the rack object that was created upon initialisation" do
      Table.new.rack.class.should == Rack
    end
  end
end


