require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Model do
  describe "get model 40h (with orientation landscape)" do
    before(:each) do
      @model = Model.get_model("40h", :landscape)
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

    it "should have 1 frame" do
      @model.num_quadrants.should == 1
    end

    it "should have a name of 40h" do
      @model.name.should == "40h"
    end

    it "should have a width of 8" do
      @model.width.should == 8
    end

    it "should have a height of 8" do
      @model.height.should == 8
    end
  end

  describe "get model 40h (with orientation portrait)" do
    it "should raise an InvalidOrientation error" do
      lambda{Model.get_model("40h", :portrait)}.should raise_error(Model::InvalidOrientation)
    end
  end

  describe "get model 64 (with orientation landscape)" do
    before(:each) do
      @model = Model.get_model("64", :landscape)
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

    it "should have 1 frame" do
      @model.num_quadrants.should == 1
    end

    it "should have a name of 64" do
      @model.name.should == "64"
    end

    it "should have a width of 8" do
      @model.width.should == 8
    end

    it "should have a height of 8" do
      @model.height.should == 8
    end
  end

  describe "get model 64 (with orientation portrait)" do
    it "should raise an InvalidOrientation error" do
      lambda{Model.get_model("64", :portrait)}.should raise_error(Model::InvalidOrientation)
    end
  end

  describe "get model 128 (with orientation landscape)" do
    before(:each) do
      @model = Model.get_model("128")
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

    it "should have 2 frames" do
      @model.num_quadrants.should == 2
    end

    it "should have a name of 128" do
      @model.name.should == "128"
    end

    it "should have a width of 16" do
      @model.width.should == 16
    end

    it "should have a height of 8" do
      @model.height.should == 8
    end
  end

  describe "get model 128 (with orientation portrait)" do
    before(:each) do
      @model = Model.get_model("128", :portrait)
    end

    it "should have a width of 8" do
      @model.width.should == 8
    end

    it "should have a height of 16" do
      @model.height.should == 16
    end

    it "should use the series protocol" do
      @model.protocol.should == "series"
    end

    it "should have 2 frames" do
      @model.num_quadrants.should == 2
    end

    it "should have a name of 128" do
      @model.name.should == "128"
    end

    it "should have a width of 8" do
      @model.width.should == 8
    end

    it "should have a height of 16" do
      @model.height.should == 16
    end
  end

  describe "get model 256 (with orientation landscape)" do
    before(:each) do
      @model = Model.get_model("256", :landscape)
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

    it "should have 4 frames" do
      @model.num_quadrants.should == 4
    end

    it "should have a name of 256" do
      @model.name.should == "256"
    end

    it "should have a width of 16" do
      @model.width.should == 16
    end

    it "should have a height of 16" do
      @model.height.should == 16
    end
  end

  describe "get model 256 (with orientation portrait" do
    it "should raise an InvalidOrientation error" do
      lambda{Model.get_model("256", :portrait)}.should raise_error(Model::InvalidOrientation)
    end
  end

  describe "get unknown model" do
    it "should raise an ArgumentError" do
      lambda{Model.get_model("uknown_model")}.should raise_error(ArgumentError)
    end
  end
end
