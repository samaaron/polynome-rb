require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Quadrants do
  it "should resolve to the correct constant from this context" do
    Quadrants.should == Polynome::Quadrants
  end

  describe "#initialize" do
    it "should raise a QuadrantCountError if not enough quadrants are specified" do
      lambda{Quadrants.new([])}.should raise_error(Quadrants::QuadrantCountError)
    end

    it "should raise a QuadrantCountError if more than 4 quadrants are specified" do
      lambda{Quadrants.new([1,2,3,4,5])}.should raise_error(Quadrants::QuadrantCountError)
    end

    it "should raise a QuadrantCountError if 3 quadrants are specified" do
      lambda{Quadrants.new([1,2,3])}.should raise_error(Quadrants::QuadrantCountError)
    end

    it "should raise a QuadrantIDError if a quadrant id other than 1,2 or 3 is used" do
      lambda{Quadrants.new([:a, 2, 3, 4])}.should raise_error(Quadrants::QuadrantIDError)
    end
  end

  describe "#count" do
    it "should know that an individual quadrant has a count of one" do
      Quadrants.new([1]).count.should == 1
    end

    it "should know that a pair of quadrants has a count of two" do
      Quadrants.new([1,2]).count.should == 2
    end

    it "should know that a full set of quadrants has a count of four" do
      Quadrants.new([1,2,3,4]).count.should == 4
    end
  end
end
