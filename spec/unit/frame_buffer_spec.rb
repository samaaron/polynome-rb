require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe FrameBuffer do
  it "should resolve the correct constant from this context" do
    FrameBuffer.should == Polynome::FrameBuffer
  end
end
