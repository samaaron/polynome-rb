require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Model do
  describe "get model 40h" do
    before(:each) do
      @model = Model.get_model("40h")
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

    describe "with orientations" do
      [:top, :bottom, :left, :right].each do |orientation|

        describe "with orientation #{orientation}" do

          it "should have a width of 8" do
            @model.width_with_orientation(orientation).should == 8
          end

          it "should have a height of 8" do
            @model.height_with_orientation(orientation).should == 8
          end
        end
      end
    end
  end

  describe "get model 64" do
    before(:each) do
      @model = Model.get_model("64")
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

     describe "with orientations" do
      [:top, :bottom, :left, :right].each do |orientation|

        describe "with orientation #{orientation}" do

          it "should have a width of 8" do
            @model.width_with_orientation(orientation).should == 8
          end

          it "should have a height of 8" do
            @model.height_with_orientation(orientation).should == 8
          end
        end
      end
    end
  end

  describe "get model 128" do
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

    describe "with orientations" do
      [:top, :bottom].each do |orientation|
        describe "with orientation #{orientation}" do
          it "should have a width of 16" do
            @model.width_with_orientation(orientation).should == 16
          end

          it "should have a height of 8" do
            @model.height_with_orientation(orientation).should == 8
          end
        end
      end

      [:left, :right].each do |orientation|
        describe "with orientation #{orientation}" do
          it "should have a width of 8" do
            @model.width_with_orientation(orientation).should == 8
          end

          it "should have a height of 16" do
            @model.height_with_orientation(orientation).should == 16
          end
        end
      end
    end
  end

  describe "get model 256" do
    before(:each) do
      @model = Model.get_model("256")
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

    describe "with orientations" do
      [:top, :bottom, :left, :right].each do |orientation|

        describe "with orientation #{orientation}" do

          it "should have a width of 16" do
            @model.width_with_orientation(orientation).should == 16
          end

          it "should have a height of 16" do
            @model.height_with_orientation(orientation).should == 16
          end
        end
      end
    end
  end

  describe "get unknown model" do
    it "should raise an ArgumentError" do
      lambda{Model.get_model("uknown_model")}.should raise_error(ArgumentError)
    end
  end
end
