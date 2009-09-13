require File.dirname(__FILE__) + '/../spec_helper.rb'

describe MonomeSerial::Transposer do
  it "should exist" do
    MonomeSerial::Transposer.should_not be_nil
  end

  describe "with an unknown mapping" do
    it "should raise an ArugmentError" do
      lambda{MonomeSerial::Transposer.new("unknown_mapping")}.should raise_error(ArgumentError)
    end
  end

  describe "with 40h mappings" do
    before(:each) do
      @transposer = MonomeSerial::Transposer.new("40h")
    end

    it "should have a max height of 7" do
      @transposer.max_height.should == 7
    end

    it "should have a max width of 7" do
      @transposer.max_width.should == 7
    end
  end

  describe "with 64 mappings" do
    before(:each) do
      @transposer = MonomeSerial::Transposer.new("64")
    end

    it "should have a max height of 7" do
      @transposer.max_height.should == 7
    end

    it "should have a max width of 7" do
      @transposer.max_width.should == 7
    end
  end

  describe "with 128 mappings" do
    before(:each) do
      @transposer = MonomeSerial::Transposer.new("128")
    end

    it "should have a max height of 7" do
      @transposer.max_height.should == 7
    end

    it "should have a max width of 15" do
      @transposer.max_width.should == 15
    end
  end

  describe "with 256 mappings" do
    before(:each) do
      @transposer = MonomeSerial::Transposer.new("256")
    end

    it "should have a max height of 15" do
      @transposer.max_height.should == 15
    end

    it "should have a max width of 15" do
      @transposer.max_width.should == 15
    end
  end

end
