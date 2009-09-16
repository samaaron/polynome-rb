require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe MonomeModel do
  describe "get model 40h" do
    before(:each) do
      @model = MonomeModel.get_model("40h")
    end

    it "should have a width of 8" do
      @model.width.should == 8
    end

    it "should have a height of 8" do
      @model.height.should == 8
    end

    it "should use the 40h protocol" do
      @model.protocol.should == "40h"
    end
  end

  describe "get model 64" do
    before(:each) do
      @model = MonomeModel.get_model("64")
    end

    it "should have a width of 8" do
      @model.width.should == 8
    end

    it "should have a height of 8" do
      @model.height.should == 8
    end

    it "should use the series protocol" do
      @model.protocol.should == "series"
    end
  end

  describe "get model 128" do
    before(:each) do
      @model = MonomeModel.get_model("128")
    end

    it "should have a width of 16" do
      @model.width.should == 16
    end

    it "should have a height of 8" do
      @model.height.should == 8
    end

    it "should use the series protocol" do
      @model.protocol.should == "series"
    end
  end

  describe "get model 256" do
    before(:each) do
      @model = MonomeModel.get_model("256")
    end

    it "should have a width of 16" do
      @model.width.should == 16
    end

    it "should have a height of 16" do
      @model.height.should == 16
    end

    it "should use the series protocol" do
      @model.protocol.should == "series"
    end
  end

  describe "get unknown model" do
    it "should raise an ArgumentError" do
      lambda{MonomeModel.get_model("uknown_model")}.should raise_error(ArgumentError)
    end
  end
end
