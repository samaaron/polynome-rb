require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe "sanity check" do
  it "should resolve to the correct constant from this context" do
    Quadrants.should == Polynome::Quadrants
  end
end

describe Quadrants, "class methods" do
  describe ".get_valid_quadrants" do
    it "should raise an error if the quadrant count is below 1" do
      lambda{Quadrants.get_valid_quadrants(0)}.should raise_error(Quadrants::QuadrantCountError)
    end

    it "should raise an error if the quadrant count is above 4" do
      lambda{Quadrants.get_valid_quadrants(5)}.should raise_error(Quadrants::QuadrantCountError)
    end

    it "should return all valid single quadrants" do
      Quadrants.get_valid_quadrants(1).should == [
                                                  Quadrants.new([1]),
                                                  Quadrants.new([2]),
                                                  Quadrants.new([3]),
                                                  Quadrants.new([4])
                                                 ]
    end

    it "should return all valid quadrants pairs" do
      Quadrants.get_valid_quadrants(2).should == [
                                                  Quadrants.new([1,2]),
                                                  Quadrants.new([1,3]),
                                                  Quadrants.new([2,4]),
                                                  Quadrants.new([3,4])
                                                 ]
    end

    it "should return the valid quadrants quadruplet" do
      Quadrants.get_valid_quadrants(4).should == [
                                                  Quadrants.new([1,2,3,4])
                                                 ]
    end

  end
end

describe Quadrants do
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

  describe "#==" do
    it "should see two quadrants containing the same single quadrant id as similar" do
      Quadrants.new([1]).should == Quadrants.new([1])
    end

    it "should see two quadrants with different singular quadrant id as not similar" do
      Quadrants.new([1]).should_not == Quadrants.new([2])
    end

    it "should see two quadrants with the same multiple quadrant ids as similar" do
      Quadrants.new([1, 2]).should == Quadrants.new([1, 2])
    end

    it "should see two quadrants with the same quadrant ids, yet specified in different orders, as similar" do
      Quadrants.new([1, 2]).should == Quadrants.new([2, 1])
    end

    it "should see two quadrants with different multiple quadrant ids as different" do
      Quadrants.new([1]).should_not == Quadrants.new([1,2])
    end
  end
end
