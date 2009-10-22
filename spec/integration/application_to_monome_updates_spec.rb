require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome
describe "Application to Monome updates" do
  before(:each) do
    Application.reset_registered_applications!
  end

  describe "Basic 64 app viewing with different projection rotations" do
    describe "With a 64 monome with the default cable orientation (left) and a 64 app" do
      before(:each) do
        @monome    = Monome.new(:io_file => 'foo/bar', :model => "64")
        @app64     = Application.new(:model => 64, :name => "app64")
      end

      it "should rotate the frame 90 with a projection rotation of 90" do
        @monome.fetch_surface(:base).register_application(@app64, :quadrant => 1, :rotation => 90)
        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64_90)
        @app64.update_display(FrameFixtures.frame64)
      end

      it "should rotate the frame 90 with a projection rotation of 180" do
        @monome.fetch_surface(:base).register_application(@app64, :quadrant => 1, :rotation => 180)
        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64_180)
        @app64.update_display(FrameFixtures.frame64)
      end

      it "should rotate the frame 90 with a projection rotation of 270" do
        @monome.fetch_surface(:base).register_application(@app64, :quadrant => 1, :rotation => 270)
        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64_270)
        @app64.update_display(FrameFixtures.frame64)
      end
    end
  end

  describe "Given a 128 with the default cable orientation" do
    before(:each) do
      @monome    = Monome.new(:io_file => 'foo/bar', :model => "128")
      @surface   = @monome.fetch_surface(:base)
    end

    describe "With two 64 apps" do
      before(:each) do
        @app64_1 = Application.new(:model => 64, :name => "app64_1")
        @app64_2 = Application.new(:model => 64, :name => "app64_2")
      end

      describe "When registered with the surface with no rotation in the projection" do
        before(:each) do
          @surface.register_application(@app64_1, :quadrant => 1)
          @surface.register_application(@app64_1, :quadrant => 2)
        end

        it "on updating the display of the first app, should only illuminate the first frame with no rotation applied" do
          @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64)
          @app64_1.update_display(FrameFixtures.frame64)
        end
      end
    end
  end
end
