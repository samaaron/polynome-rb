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

    it "should have a name of 40h" do
      @model.name.should == "40h"
    end

    it "should have a width of 8" do
      @model.width.should == 8
    end

    it "should have a height of 8" do
      @model.height.should == 8
    end

    it "should have an orientation of landscape" do
      @model.orientation.should == :landscape
    end
  end

  describe "get model 64" do
    before(:each) do
      @model = Model.get_model("64")
    end

    it "should have an orientation of landscape" do
      @model.orientation.should == :landscape
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

    describe "quadrant mapping" do
      quadrant_mappings = {
        [1,1] => 1,
        [1,8] => 1,
        [2,1] => 1,
        [7,1] => 1,
        [4,8] => 1,
        [5,5] => 1,
        [2,8] => 1
      }

      quadrant_mappings.each do |mapped_coords, quadrant_id|
        it "should map the mapped coords #{mapped_coords.inspect} to the quadrant #{quadrant_id}" do
          @model.button_quadrant(mapped_coords[0], mapped_coords[1]).should == quadrant_id
        end
      end
    end
  end

  describe "get model 128 (with no rotation)" do
    before(:each) do
      @model = Model.get_model("128")
    end

    it "should have an orientation of landscape" do
      @model.orientation.should == :landscape
    end

    it "should use the series protocol" do
      @model.protocol.should == "series"
    end

    it "should have 2 frames" do
      @model.num_quadrants.should == 2
    end

    it "should have a name of 128" do
      @model.name.should == "128-landscape"
    end

    it "should have a width of 16" do
      @model.width.should == 16
    end

    it "should have a height of 8" do
      @model.height.should == 8
    end

    describe "quadrant mapping" do
      quadrant_mappings = {
        [1,1]  => 1,
        [1,8]  => 1,
        [9,1]  => 2,
        [8,1]  => 1,
        [9,8]  => 2,
        [16,8] => 2,
        [10,4] => 2
      }

      quadrant_mappings.each do |mapped_coords, quadrant_id|
        it "should map the mapped coords #{mapped_coords.inspect} to the quadrant #{quadrant_id}" do
          @model.button_quadrant(mapped_coords[0], mapped_coords[1]).should == quadrant_id
        end
      end
    end
  end

  describe "get model 128 (with 90 degrees rotation)" do
    before(:each) do
      @model = Model.get_model("128", :rotation => 90)
    end

    it "should have an orientation of portrait" do
      @model.orientation.should == :portrait
    end


    it "should use the series protocol" do
      @model.protocol.should == "series"
    end

    it "should have 2 frames" do
      @model.num_quadrants.should == 2
    end

    it "should have a name of 128" do
      @model.name.should == "128-landscape"
    end

    it "should have a width of 16" do
      @model.width.should == 16
    end

    it "should have a height of 8" do
      @model.height.should == 8
    end

    describe "quadrant mapping" do
      quadrant_mappings = {
        [1,1]  => 1,
        [1,8]  => 1,
        [9,1]  => 2,
        [9,8]  => 2,
        [16,8] => 2,
        [4,6]  => 1
      }

      quadrant_mappings.each do |mapped_coords, quadrant_id|
        it "should map the mapped coords #{mapped_coords.inspect} to the quadrant #{quadrant_id}" do
          @model.button_quadrant(mapped_coords[0], mapped_coords[1]).should == quadrant_id
        end
      end
    end
  end

  describe "get model 256" do
    before(:each) do
      @model = Model.get_model("256")
    end

    it "should have an orientation of landscape" do
      @model.orientation.should == :landscape
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

    describe "quadrant mapping" do
      quadrant_mappings = {
        [1,1]   => 3,
        [1,16]  => 1,
        [16,1]  => 4,
        [16,16] => 2,
        [2,3]   => 3,
        [11,12] => 2,
        [4,10]  => 1,
        [9,6]   => 4
      }

      quadrant_mappings.each do |mapped_coords, quadrant_id|
        it "should map the mapped coords #{mapped_coords.inspect} to the quadrant #{quadrant_id}" do
          @model.button_quadrant(mapped_coords[0], mapped_coords[1]).should == quadrant_id
        end
      end
    end
  end


  describe "get unknown model" do
    it "should raise an ArgumentError" do
      lambda{Model.get_model("uknown_model")}.should raise_error(ArgumentError)
    end
  end

  describe "a 256 with cable placement top" do
    before(:each) do
      @model = Model.get_model("256", :cable_placement => :top)
    end

    describe "coord mapping" do
      coord_mappings = {
        [0,0]   => [16,16],
        [15,15] => [1,1],
        [13,13] => [3,3],
        [13,4]  => [12,3],
        [7,14]  => [2,9],
        [6,2]   => [14,10]
      }

      coord_mappings.each do |raw, mapped|
        it "should map coords #{raw.inspect} to #{mapped.inspect}" do
          @model.map_coords_based_on_rotation(raw[0], raw[1]).should == mapped
        end
      end
    end

  end

  describe "a 256 with cable placement right" do
    before(:each) do
      @model = Model.get_model("256", :cable_placement => :right)
    end

    describe "coord mapping" do
      coord_mappings = {
        [0,15]  => [16,16],
        [15,0]  => [1,1],
        [13,3]  => [3,4],
        [4,2]   => [12,3],
        [14,8]  => [2,9],
        [2,9]   => [14,10]
      }

      coord_mappings.each do |raw, mapped|
        it "should map coords #{raw.inspect} to #{mapped.inspect}" do
          @model.map_coords_based_on_rotation(raw[0], raw[1]).should == mapped
        end
      end
    end
  end

  describe "a 256 with cable placement bottom" do
    before(:each) do
      @model = Model.get_model("256", :cable_placement => :bottom)
    end

    describe "coord mapping" do
      coord_mappings = {
        [15,15] => [16,16],
        [0,0]   => [1,1],
        [2,2]   => [3,3],
        [2,11]  => [12,3],
        [8,1]   => [2,9],
        [9,13]  => [14,10]
      }

      coord_mappings.each do |raw, mapped|
        it "should map coords #{raw.inspect} to #{mapped.inspect}" do
          @model.map_coords_based_on_rotation(raw[0], raw[1]).should == mapped
        end
      end
    end
  end

  describe "a 256 with cable placement left" do
    before(:each) do
      @model = Model.get_model("256", :cable_placement => :left)
    end

    describe "coord mapping" do
      coord_mappings = {
        [15,0]  => [16,16],
        [0,15]  => [1,1],
        [2,13]  => [3,3],
        [11,13] => [12,3],
        [1,7]   => [2,9],
        [13,6]  => [14,10]
      }

      coord_mappings.each do |raw, mapped|
        it "should map coords #{raw.inspect} to #{mapped.inspect}" do
          @model.map_coords_based_on_rotation(raw[0], raw[1]).should == mapped
        end
      end
    end
  end
end
