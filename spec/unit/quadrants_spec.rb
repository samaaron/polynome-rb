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

    it "should raise a QuadrantCombinationError if an incorrect combination is used" do
      lambda{Quadrants.new([1,4])}.should raise_error(Quadrants::QuadrantCombinationError)
    end

    describe "creating valid quadrants" do
      it "should be possible to create from the id of 1" do
        lambda{Quadrants.new([1])}.should_not raise_error
      end

      it "should be possible to create from the id of 2" do
        lambda{Quadrants.new([2])}.should_not raise_error
      end

      it "should be possible to create from the id of 3" do
        lambda{Quadrants.new([3])}.should_not raise_error
      end

      it "should be possible to create from the id of 4" do
        lambda{Quadrants.new([4])}.should_not raise_error
      end

      it "should be possible to create from the ids 1, 2" do
        lambda{Quadrants.new([1, 2])}.should_not raise_error
      end

      it "should be possible to create from the ids 1, 3" do
        lambda{Quadrants.new([1, 3])}.should_not raise_error
      end

      it "should be possible to create from the ids 2, 4" do
        lambda{Quadrants.new([2, 4])}.should_not raise_error
      end

      it "should be possible to create from the ids 3, 4" do
        lambda{Quadrants.new([3, 4])}.should_not raise_error
      end

      it "should be possible to create from the ids 1,2,3,4" do
        lambda{Quadrants.new([1,2,3,4])}.should_not raise_error
      end
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

  describe "#include?" do
    it "should return true if the quadrant id is in the set of quadrants" do
      Quadrants.new([1]).include?(1).should == true
      Quadrants.new([1,2]).include?(2).should == true
      Quadrants.new([1,2,3,4]).include?(3).should == true
    end

    it "should return false if the quadrant id is not in the set of quadrants" do
      Quadrants.new([1]).include?(0).should == false
      Quadrants.new([1,2]).include?(3).should == false
      Quadrants.new([1,2,3,4]).include?(5).should == false
      Quadrants.new([1,2,3,4]).include?("cheese").should == false
    end
  end

  describe "#size" do
    it "should indicate that a set of quadrants with one id has a size of one" do
      Quadrants.new([1]).size.should == 1
    end

    it "should indicate that a set of quadrants with two ids has a size of two" do
      Quadrants.new([1, 2]).size.should == 2
    end

    it "should indicate that a set of quadrants with four ids has a size of four" do
      Quadrants.new([1, 2, 3, 4]).size.should == 4
    end
  end

  describe "#index" do
    it "should return the index of the id if present" do
      Quadrants.new([1]).index(1).should == 0
      Quadrants.new([1,2]).index(2).should == 1
      Quadrants.new([1,2,3,4]).index(4).should == 3
    end

    it "should be able to take a block to perform matching" do
      Quadrants.new([1, 2]).index{|i| i > 1}.should == 1
    end

    it "should return nil if no match is found" do
      Quadrants.new([1]).index(2).should == nil
      Quadrants.new([1, 2]).index(0).should == nil
      Quadrants.new([1, 2, 3, 4]).index(5).should == nil
      Quadrants.new([1, 2]).index{|i| i > 10}.should == nil
    end
  end

  describe "#to_a" do
    it "should return an array containing the quadrant ids" do
      Quadrants.new([1]).to_a.should == [1]
      Quadrants.new([1,2]).to_a.should == [1,2]
      Quadrants.new([1,2,3,4]).to_a.should == [1,2,3,4]
      Quadrants.new([4,3,2,1]).to_a.should == [1,2,3,4]
    end
  end


  describe "#[]" do
    it "should return a 0 indexed element from the list of quadrant ids" do
      Quadrants.new([1])[0].should == 1
      Quadrants.new([1,2])[1].should == 2
      Quadrants.new([1,2,3,4])[2].should == 3
    end

    it "should raise an error if the index is out of bounds" do
      lambda{Quadrants.new([1])[-10]}.should raise_error(Quadrants::QuadrantIndexOutOfBoundsError)
      lambda{Quadrants.new([1,2])[2]}.should raise_error(Quadrants::QuadrantIndexOutOfBoundsError)
      lambda{Quadrants.new([1,2,3,4])[10]}.should raise_error(Quadrants::QuadrantIndexOutOfBoundsError)
    end
  end
end
