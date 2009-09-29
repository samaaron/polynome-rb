require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe 'sanity check' do
  it "should resolve the constant correctly from this context" do
    Projection.should == Polynome::Projection
  end

  describe "#initialize" do
    before(:each) do
      @app = AppConnector.new(:model => "64")
      @quadrants = Quadrants.new([1,2])
    end

    it "should raise an error when given an invalid rotation" do
      lambda{Projection.new(@app, 1080, @quadrants)}.should raise_error(ArgumentError)
    end

    it "should store the app connector" do
      Projection.new(@app, 0, @quadrants).app.should == @app
    end

    it "should store the rotation" do
      Projection.new(@app, 0, @quadrants).rotation.should == 0
    end

    it "should store the quadrants" do
      Projection.new(@app, 0, @quadrants).quadrants.should == @quadrants
    end
  end
end
