require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Frame do
  it "should point to the correct constant from this context" do
    Frame.should == Polynome::Frame
  end

  describe "initialisation with a binary string" do
    it "should be possible to create a frame with a 64 bit binary string" do
      lambda{Frame.new("0000000000000000000000000000000000000000000000000000000000000000")}.should_not raise_error
    end

    it "should raise an error if too few bits are used to create it" do
      lambda{Frame.new("000000000000000000000000000000000000000000000000000000000000000")}.should raise_error(ArgumentError)
    end

    it "should raise an error if too many bits are used to created it" do
      lambda{Frame.new("00000000000000000000000000000000000000000000000000000000000000000")}.should raise_error(ArgumentError)
    end
  end

  describe "with a frame initialised with a 64 bit string of 0s" do
    before(:each) do
      string = "0000000000000000000000000000000000000000000000000000000000000000"
      @frame = Frame.new(string)
    end

    describe "#read" do
      it "should return an 8 by 8 array of 0s" do
        @frame.read.should == [
                               "00000000", "00000000", "00000000", "00000000",
                               "00000000", "00000000", "00000000", "00000000"
                              ]
      end
    end

    describe "#invert!" do
      it "should invert the frame to all 1s" do
        @frame.invert!
        @frame.read.should == [
                               "11111111", "11111111", "11111111", "11111111",
                               "11111111", "11111111", "11111111", "11111111"
                              ]
      end
    end
  end

  describe "with a frame initialised intitialised with a 64 bit string of 1s" do
    before do
      string = "1111111111111111111111111111111111111111111111111111111111111111"
      @frame = Frame.new(string)
    end

    describe "#read" do

      it "should return an 8 by 8 array of 1s" do

        @frame.read.should == [
                               "11111111", "11111111", "11111111", "11111111",
                               "11111111", "11111111", "11111111", "11111111"
                              ]
      end
    end

    describe "#invert!" do
      it "should invert the frame to all 0s" do
        @frame.invert!
        @frame.read.should == [
                               "00000000", "00000000", "00000000", "00000000",
                               "00000000", "00000000", "00000000", "00000000"
                              ]
      end
    end
  end

  describe "with a frame initialised with a 64 bit string of alternating 1s and 0s" do
    before do
      string = "1010101010101010101010101010101010101010101010101010101010101010"
      @frame = Frame.new(string)
    end

    describe "#read" do
      it "should return an 8 by 8 array of alternating 1s and 0s" do
        @frame.read.should == [
                               "10101010", "10101010", "10101010", "10101010",
                               "10101010", "10101010", "10101010", "10101010"
                              ]
      end
    end

    describe "#invert!" do
      it "should invert the frame to alternating 0s and 1s" do
        @frame.invert!
        @frame.read.should == [
                               "01010101", "01010101", "01010101", "01010101",
                               "01010101", "01010101", "01010101", "01010101"
                              ]
      end
    end
  end

  describe "with a frame initialised with a 64 bit string of random bits" do
    before do
      string = "1100001010101110100001010100101101010101111111100000101010000010"
      @frame = Frame.new(string)
    end

    describe "#read" do
      it "should return an 8 by 8 array corresponding to the original string" do

        @frame.read.should == [
                               "11000010", "10101110", "10000101", "01001011",
                               "01010101", "11111110", "00001010", "10000010"
                              ]
      end
    end

    describe "#invert!" do
      it "should invert the frame appropriately" do
        @frame.invert!
        @frame.read.should == [
                               "00111101", "01010001", "01111010", "10110100",
                               "10101010", "00000001", "11110101", "01111101"
                              ]
      end
    end
  end
end
