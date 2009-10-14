require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe 'sanity check' do
  it "should resolve the constant correctly from this context" do
    Projection.should == Polynome::Projection
  end
end

describe Projection do
  before(:each) {Application.reset_registered_applications!}

  describe "with a 64 app" do
    describe "#initialize" do
      before(:each) do
        @app = Application.new(:model => "64", :name => "test")
        @quadrants = Quadrants.new([1])
      end

      it "should raise an error when given an invalid rotation" do
        lambda{Projection.new(@app, 1080, @quadrants)}.should raise_error(ArgumentError)
      end

      it "should store the app" do
        Projection.new(@app, 0, @quadrants).application.should == @app
      end

      it "should store the rotation" do
        Projection.new(@app, 0, @quadrants).rotation.should == 0
      end

      it "should store the quadrants" do
        Projection.new(@app, 0, @quadrants).quadrants.should == @quadrants
      end

      describe "valid rotations" do
        it "should allow initialisation with a rotation of 0" do
          lambda{Projection.new(@app, 0, @quadrants)}.should_not raise_error
        end

        it "should allow initialisation with a rotation of 90" do
          lambda{Projection.new(@app, 90, @quadrants)}.should_not raise_error
        end

        it "should allow initialisation with a rotation of 180" do
          lambda{Projection.new(@app, 180, @quadrants)}.should_not raise_error
        end

        it "should allow initialisation with a rotation of 270" do
          lambda{Projection.new(@app, 270, @quadrants)}.should_not raise_error
        end
      end
    end
  end

  describe "with a 128 landscape app" do
    before(:each) do
      @app = Application.new(:model => "128", :orientation => :landscape, :name => "test")
      @quadrants = Quadrants.new([1,2])
    end

    describe "#inititialize" do
      describe "valid rotations" do
        it "should allow initialisation with a rotation of 0" do
          lambda{Projection.new(@app, 0, @quadrants)}.should_not raise_error
        end

        it "should not allow initialisation with a rotation of 90" do
          lambda{Projection.new(@app, 90, @quadrants)}.should raise_error(Projection::RotationOrientationMismatchError)
        end

        it "should allow initialisation with a rotation of 180" do
          lambda{Projection.new(@app, 180, @quadrants)}.should_not raise_error
        end

        it "should not allow initialisation with a rotation of 270" do
          lambda{Projection.new(@app, 270, @quadrants)}.should raise_error(Projection::RotationOrientationMismatchError)
        end
      end
    end
  end

  describe "with a 128 portrait app" do
    before(:each) do
      @app = Application.new(:model => "128", :orientation => :portrait, :name => "test")
      @quadrants = Quadrants.new([1,3])
    end

    describe "#inititialize" do
      describe "valid rotations" do
        it "should allow initialisation with a rotation of 0" do
          lambda{Projection.new(@app, 0, @quadrants)}.should_not raise_error
        end

        it "should not allow initialisation with a rotation of 90" do
          lambda{Projection.new(@app, 90, @quadrants)}.should raise_error(Projection::RotationOrientationMismatchError)
        end

        it "should allow initialisation with a rotation of 180" do
          lambda{Projection.new(@app, 180, @quadrants)}.should_not raise_error
        end

        it "should not allow initialisation with a rotation of 270" do
          lambda{Projection.new(@app, 270, @quadrants)}.should raise_error(Projection::RotationOrientationMismatchError)
        end
      end
    end
  end
end
