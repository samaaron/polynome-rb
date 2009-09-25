require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Surface do
  it "should resolve to the correct constant from this context" do
    Surface.should == Polynome::Surface
  end

  describe "#initialize" do
    it "should be possible to initialize a surface specifying the number of frames that surface consists of" do
      lambda{Surface.new("test", 1)}.should_not raise_error
    end

    it "should raise an ArgumentError if the number of frames specified is less than 1" do
      lambda{Surface.new("test", 0)}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if the number of frames specified is 3" do
      lambda{Surface.new("test", 3)}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if the number of frames specified is greater than 4" do
      lambda{Surface.new("test", 5)}.should raise_error(ArgumentError)
    end
  end

  describe "#num_frames" do
    it "should report the number of frames the surface has" do
      Surface.new("test", 4).num_frames.should == 4
    end

    it "should report that a surface initialised with four frames has four frames" do
      Surface.new("test", 4).num_frames.should == 4
    end

    it "should report that a sufrace initialised with two frames has two frames" do
      Surface.new("test", 2).num_frames.should == 2
    end
  end

  describe "#update_frame_buffer" do
    it "should raise an ArgumentError if no frames are sent" do
      lambda{Surface.new("test", 1).update_display()}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if a frame with an index of 0 is sent" do
      frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
      lambda{Surface.new("test", 1).update_display(0, frame)}.should raise_error(ArgumentError)
    end
  end

  describe "given a surface with 1 frame" do
    before(:each) do
      @surface = Surface.new("test", 1)
    end

    it "should only have one frame" do
      @surface.num_frames.should == 1
    end

    describe "#update_display" do
      it "should raise an ArgumentError if a frame with an index of 2 is sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface.update_display(2, frame)}.should raise_error(ArgumentError)
      end
    end
  end

  describe "given a surface with 2 frames" do
    before(:each) do
      @surface = Surface.new("test", 2)
    end

    it "should have two frames" do
      @surface.num_frames.should == 2
    end

    describe "#update_display" do
      it "should raise an ArgumentError if with an index of 3 sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface.update_display(3, frame)}.should raise_error(ArgumentError)
      end
    end
  end

  describe "given a surface with 4 frames" do
    before(:each) do
      @surface = Surface.new("test", 4)
    end

    it "should have four frames" do
      @surface.num_frames.should == 4
    end

    describe "#update_display" do
      it "should raise an ArgumentError if a frame with an index of 5 is sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface.update_display(5, frame)}.should raise_error(ArgumentError)
      end
    end
  end
end
