require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome
describe "Application to Monome updates" do
  before(:each) do
    Application.reset_registered_applications!
  end

  describe "Given a mocked out monome communicator" do
    before(:each) do
      @comm   = MonomeSerial::MonomeCommunicator.new('foo/bar', "series")
      MonomeSerial::MonomeCommunicator.should_receive(:new).and_return(@comm)
    end

    describe "Basic 64 app viewing with default projections" do
      describe "With a 64 monome and a 64 app registered on its base surface with the default projection" do
        before(:each) do
          monome    = Monome.new(:io_file => 'foo/bar', :model => "64")
          @app64     = Application.new(:model => 64, :name => "app64")
          monome.fetch_surface(:base).register_application(@app64, :quadrant => 1)
        end

        it "should pass the frame correctly from application to surface" do
          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64)
          @app64.update_display(FrameFixtures.frame64)
        end
      end

      describe "With a 64 monome with cable orientation top with an app registered on its base surface with the default projection" do
        before(:each) do
          monome    = Monome.new(:io_file => 'foo/bar', :model => "64", :cable_orientation => :top)
          @app64     = Application.new(:model => 64, :name => "app64")
          monome.fetch_surface(:base).register_application(@app64, :quadrant => 1)
        end

        it "should pass the frame correctly from application to surface with a rotation of 270" do
          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64_270)
          @app64.update_display(FrameFixtures.frame64)
        end
      end

      describe "With a 64 monome with cable orientation right with an app registered on its base surface with the default projection" do
        before(:each) do
          monome    = Monome.new(:io_file => 'foo/bar', :model => "64", :cable_orientation => :right)
          @app64     = Application.new(:model => 64, :name => "app64")
          monome.fetch_surface(:base).register_application(@app64, :quadrant => 1)
        end

        it "should pass the frame correctly from application to surface with a rotation of 90" do
          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64_90)
          @app64.update_display(FrameFixtures.frame64)
        end
      end

      describe "With a 64 monome with cable orientation bottom with an app registered on its base surface with the default projection" do
        before(:each) do
          monome    = Monome.new(:io_file => 'foo/bar', :model => "64", :cable_orientation => :bottom)
          @app64     = Application.new(:model => 64, :name => "app64")
          monome.fetch_surface(:base).register_application(@app64, :quadrant => 1)
        end

        it "should pass the frame correctly from application to surface with a rotation of 180" do
          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64_180)
          @app64.update_display(FrameFixtures.frame64)
        end
      end
    end

    describe "Basic 64 app viewing with different projection rotations" do
      describe "With a 64 monome with the default cable orientation (left) and a 64 app" do
        before(:each) do
          @monome    = Monome.new(:io_file => 'foo/bar', :model => "64")
          @app64     = Application.new(:model => 64, :name => "app64")
        end

        it "should rotate the frame 90 with a projection rotation of 90" do
          @monome.fetch_surface(:base).register_application(@app64, :quadrant => 1, :rotation => 90)
          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64_90)
          @app64.update_display(FrameFixtures.frame64)
        end

        it "should rotate the frame 90 with a projection rotation of 180" do
          @monome.fetch_surface(:base).register_application(@app64, :quadrant => 1, :rotation => 180)
          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64_180)
          @app64.update_display(FrameFixtures.frame64)
        end

        it "should rotate the frame 90 with a projection rotation of 270" do
          @monome.fetch_surface(:base).register_application(@app64, :quadrant => 1, :rotation => 270)
          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64_270)
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
            @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64)
            @app64_1.update_display(FrameFixtures.frame64)
          end
        end
      end
    end
  end
end
