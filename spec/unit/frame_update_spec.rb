require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe FrameUpdate do
  before(:each) do
    @app64 = Application.new(:device => 64, :name => "app64")
  end

  it "should resolve to the correct constant from this context" do
    Polynome::FrameUpdate.should == FrameUpdate
  end

  describe "#initialize" do
    it "should be possible to create an update with an application and some frames" do
      lambda{FrameUpdate.new(@app64, [FrameFixtures.lit, FrameFixtures.blank])}.should_not raise_error
    end
  end

  describe "#application" do
    it "should return the application it was initialised with" do
      FrameUpdate.new(@app64, [FrameFixtures.lit, FrameFixtures.blank]).application.should == @app64
    end
  end

  describe "#frames" do
    it "should return the frames it was initialised with" do
      frames = [FrameFixtures.lit, FrameFixtures.blank]
      FrameUpdate.new(@app64, frames).frames.should == frames
    end
  end
end
