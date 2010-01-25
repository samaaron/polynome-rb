require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Layer do
  it "should exist" do
    Layer.should_not be_nil
  end

  describe "with default params" do
    before :each do
      @layer = Layer.new(8, 16, "test")
    end

    it "should have a max x of 8" do
      @layer.max_x.should == 8
    end

    it "should have a max y of 16" do
      @layer.max_y.should == 16
    end
  end
end
