require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe LightBank do
  it "should exist" do
    LightBank.should_not be_nil
  end
end

describe LightBank, ", initialised with defaults" do
  before :each do
    @light_bank = LightBank.new(8, 16)
  end

  it "should start off with one layer" do
    @light_bank.num_layers.should == 1
  end

  it "should have a max x coord of 8" do
    @light_bank.max_x.should == 8
  end

  it "should have a max y coord of 16" do
    @light_bank.max_y.should == 16
  end

  it "should be able to return the current layer" do
    @light_bank.current_layer.max_x.should == 8
    @light_bank.current_layer.max_y.should == 16
  end


end
