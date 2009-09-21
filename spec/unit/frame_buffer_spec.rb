require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe FrameBuffer do
  it "should resolve the correct constant from this context" do
    FrameBuffer.should == Polynome::FrameBuffer
  end

  describe "with a defined frame" do
    before do
      @frame = Frame.new("1010101010101010101010101010101010101010101010101010101010101010")
    end

    it "should be possible to push a frame to the buffer" do
      lambda{FrameBuffer.new.push_frame(@frame)}.should_not raise_error
    end

    it "should be possible to fetch a frame from the buffer" do
      buffer = FrameBuffer.new
      buffer.push_frame(@frame)
      lambda{buffer.fetch_frame}.should_not raise_error
    end
  end

  describe "with a list of pre-defined frames" do
    before do
      @frames = [
                 Frame.new("1010101010101010101010101010101010101010101010101010101010101010"),
                 Frame.new("1111111111111111111111111111111111111111111111111111111111111111"),
                 Frame.new("0000000000000000000000000000000000000000000000000000000000000000"),
                 Frame.new("1111111111111111111111111111111100000000000000000000000000000000"),
                 Frame.new("0000000000000000000000000000000011111111111111111111111111111111"),
                 Frame.new("0101010101010101010101010101010101010101010101010101010101010101")
                ]

    end

    it "should fetch the same frames that were pushed in the correct order" do
      buffer = FrameBuffer.new
      @frames.each{|frame| buffer.push_frame(frame)}
      fetched_frames = []
      6.times{ fetched_frames << buffer.fetch_frame}
      fetched_frames.should == @frames
    end
  end

end
