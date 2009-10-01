require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe "sanity check" do
  it "should resolve to the correct constant from this context" do
    Interface.should == Polynome::Interface
  end
end

describe Interface do
  before(:each) do
    @full_frame        = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
    @blank_frame       = Frame.new("0000000000000000000000000000000000000000000000000000000000000000")
    @alternating_frame = Frame.new("1010101010101010101010101010101010101010101010101010101010101010")
  end

  describe "#initialize" do
    it "should be possible to create a new interface with a model" do
      lambda{Interface.new(Model.get_model("64"))}.should_not raise_error
    end

    it "should raise an ArgumentError if the model is not of kind model" do
      lambda{Interface.new("64")}.should raise_error(ArgumentError)
    end
  end

  describe "with a 64 interface" do
    before(:each) do
      @interface = Interface.new(Model.get_model("64"))
    end

    describe "#set_quadrant" do
      it "should raise an error if the quadrant id is less than one" do
        lambda{@interface.set_quadrant(0, @full_frame)}.should raise_error(ArgumentError)
      end

      it "should raise an error if the quadrant id is greater than one" do
        lambda{@interface.set_quadrant(2, @full_frame)}.should raise_error(ArgumentError)
      end
    end
  end

  describe "with a 128 interface" do
    before(:each) do
      @interface = Interface.new(Model.get_model("128"))
    end

    describe "#set_quadrant" do
      it "should raise an error if the quadrant id is less than one" do
        lambda{@interface.set_quadrant(0, @full_frame)}.should raise_error(ArgumentError)
      end

      it "should raise an error if the quadrant id is greater than two" do
        lambda{@interface.set_quadrant(3, @full_frame)}.should raise_error(ArgumentError)
      end
    end
  end

  describe "with a 256 interface" do
    before(:each) do
      @interface = Interface.new(Model.get_model("256"))
    end

    describe "#set_quadrant" do
      it "should raise an error if the quadrant id is less than one" do
        lambda{@interface.set_quadrant(0, @full_frame)}.should raise_error(ArgumentError)
      end

      it "should raise an error if the quadrant id is greater than four" do
        lambda{@interface.set_quadrant(5, @full_frame)}.should raise_error(ArgumentError)
      end
    end
  end
end
