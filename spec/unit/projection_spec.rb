require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe 'sanity check' do
  it "should resolve the constant correctly from this context" do
    Projection.should == Polynome::Projection
  end
end

describe Projection do
  before(:each) do
    @monome = Monome.new(:io_file => "blah", :device => "256", :cable_placement => :top)
    @surface = @monome.carousel.fetch(:base)
    @second_surface = @monome.carousel.add(:second_surface)
  end

  describe "#on_current_surface?" do
    before(:each) do
      @app = Application.new(:device=> "64", :name => "test")
      @quadrants = Quadrants.new([1])
    end

    it "should be on the current surface if the projection is registered on the base surface (before surface switching)" do
      Projection.new(@surface, @app, @quadrants).should be_on_current_surface
    end

    it "should not be on the current surface if the projection is registered on a different surface (before surface switching)" do
      Projection.new(@second_surface, @app, @quadrants).should_not be_on_current_surface
    end

    it "should be on the current surface is the monome is switched to the surface the projection was registered on" do
      projection = Projection.new(@second_surface, @app, @quadrants)
      projection.should_not be_on_current_surface
      @monome.carousel.switch_to(@second_surface.name)
      projection.should be_on_current_surface
    end

  end

  describe "with a 64 app" do
    describe "#initialize" do
      before(:each) do
        @app = Application.new(:device => "64", :name => "test")
        @quadrants = Quadrants.new([1])
      end

      it "should raise an error when given an invalid rotation" do
        lambda{Projection.new(@surface, @app, @quadrants, :rotation => 1080)}.should raise_error(ArgumentError)
      end

      it "should store the app" do
        Projection.new(@surface, @app, @quadrants).application.should == @app
      end

      it "should store the rotation" do
        Projection.new(@surface, @app, @quadrants).rotation.should == 0
      end

      it "should store the quadrants" do
        Projection.new(@surface, @app, @quadrants).quadrants.should == @quadrants
      end

      describe "valid options" do
        it "should allow initialisation with a rotation of 0" do
          lambda{Projection.new(@surface, @app, @quadrants)}.should_not raise_error
        end

        it "should allow initialisation with a rotation of 90" do
          lambda{Projection.new(@surface, @app, @quadrants, :rotation => 90)}.should_not raise_error
        end

        it "should allow initialisation with a rotation of 180" do
          lambda{Projection.new(@surface, @app, @quadrants, :rotation => 180)}.should_not raise_error
        end

        it "should allow initialisation with a rotation of 270" do
          lambda{Projection.new(@surface, @app, @quadrants, :rotation => 270)}.should_not raise_error
        end

        it "should allow initialisation with invert set to true" do
          lambda{Projection.new(@surface, @app, @quadrants, :invert => true)}.should_not raise_error
        end
      end
    end
  end

#  describe "with a 128 landscape app" do
#    before(:each) do
#      @app = Application.new(:device => "128", :name => "test")
#      @quadrants = Quadrants.new([1,2])
#    end
#
#    describe "#inititialize" do
#      describe "valid options" do
#        it "should allow initialisation with a rotation of 0" do
#          lambda{Projection.new(@surface, @app, @quadrants)}.should_not raise_error
#        end
#
#        it "should not allow initialisation with a rotation of 90" do
#          lambda{Projection.new(@surface, @app, @quadrants, :rotation => 90)}.should raise_error(Projection::RotationOrientationMismatchError)
#        end
#
#        it "should allow initialisation with a rotation of 180" do
#          lambda{Projection.new(@surface, @app, @quadrants, :rotation => 180)}.should_not raise_error
#        end
#
#        it "should not allow initialisation with a rotation of 270" do
#          lambda{Projection.new(@surface, @app, @quadrants, :rotation => 270)}.should raise_error(Projection::RotationOrientationMismatchError)
#        end
#
#        it "should allow initialisation with invert set to true" do
#          lambda{Projection.new(@surface, @app, @quadrants, :invert => true)}.should_not raise_error
#        end
#      end
#    end
#  end
#
#  describe "with a 128 portrait app" do
#    before(:each) do
#      @app = Application.new(:device=> "128", :name => "test")
#      @quadrants = Quadrants.new([1,3])
#    end
#
#    describe "#inititialize" do
#      describe "valid options" do
#        it "should allow initialisation with a rotation of 0" do
#          lambda{Projection.new(@surface, @app, @quadrants)}.should_not raise_error
#        end
#
#        it "should not allow initialisation with a rotation of 90" do
#          lambda{Projection.new(@surface, @app, @quadrants, :rotation => 90)}.should raise_error(Projection::RotationOrientationMismatchError)
#        end
#
#        it "should allow initialisation with a rotation of 180" do
#          lambda{Projection.new(@surface, @app, @quadrants, :rotation => 180)}.should_not raise_error
#        end
#
#        it "should not allow initialisation with a rotation of 270" do
#          lambda{Projection.new(@surface, @app, @quadrants, :rotation => 270)}.should raise_error(Projection::RotationOrientationMismatchError)
#        end
#
#        it "should allow initialisation with invert set to true" do
#          lambda{Projection.new(@surface, @app, @quadrants, :invert => true)}.should_not raise_error
#        end
#      end
#    end
#  end
end
