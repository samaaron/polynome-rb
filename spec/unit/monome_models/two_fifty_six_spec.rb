require File.dirname(__FILE__) + '/../../spec_helper.rb'
include Polynome

describe Monome do
  describe "Given a 256 with a mocked out monome communicator" do
    before(:each) do
      @comm   = MonomeSerial::MonomeCommunicator.new('foo/bar')
      MonomeSerial::MonomeCommunicator.should_receive(:new).and_return(@comm)
    end

    describe "With cable placment top" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "256", :cable_placement => :top)
      end

      describe "Lighting the device" do
        it "should map and rotate a frame in quadrant 1 to quadrant 3 with rotation 270" do
          @comm.should_receive(:illuminate_frame).with(3, FrameFixtures.bit_array256_1_270)
          @monome.light_quadrant(1, FrameFixtures.frame256_1)
        end

        it "should map and rotate a frame in quadrant 2 to quadrant 1 with rotation 270" do
          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array256_2_270)
          @monome.light_quadrant(2, FrameFixtures.frame256_2)
        end

        it "should map and rotate a frame in quadrant 3 to quadrant 4 with rotation 270" do
          @comm.should_receive(:illuminate_frame).with(4, FrameFixtures.bit_array256_3_270)
          @monome.light_quadrant(3, FrameFixtures.frame256_3)
        end

        it "should map and rotate a frame in quadrant 4 to quadrant 2 with rotation 270" do
          @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array256_4_270)
          @monome.light_quadrant(4, FrameFixtures.frame256_4)
        end
      end
    end

    describe "With cable placement right" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "256", :cable_placement => :right)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 4 with rotation 180" do
        @comm.should_receive(:illuminate_frame).with(4, FrameFixtures.bit_array256_1_180)
        @monome.light_quadrant(1, FrameFixtures.frame256_1)
      end

      it "should map and rotate a frame in quadrant 2 to quadrant 3 with rotation 180" do
        @comm.should_receive(:illuminate_frame).with(3, FrameFixtures.bit_array256_2_180)
        @monome.light_quadrant(2, FrameFixtures.frame256_2)
      end

      it "should map and rotate a frame in quadrant 3 to quadrant 2 with rotation 180" do
        @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array256_3_180)
        @monome.light_quadrant(3, FrameFixtures.frame256_3)
      end

      it "should map and rotate a frame in quadrant 4 to quadrant 1 with rotation 180" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array256_4_180)
        @monome.light_quadrant(4, FrameFixtures.frame256_4)
      end
    end

    describe "With cable placement bottom" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "256", :cable_placement => :bottom)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 2 with rotation 90" do
        @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array256_1_90)
        @monome.light_quadrant(1, FrameFixtures.frame256_1)
      end

      it "should map and rotate a frame in quadrant 2 to quadrant 4 with rotation 90" do
        @comm.should_receive(:illuminate_frame).with(4, FrameFixtures.bit_array256_2_90)
        @monome.light_quadrant(2, FrameFixtures.frame256_2)
      end

      it "should map and rotate a frame in quadrant 3 to quadrant 1 with rotation 90" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array256_3_90)
        @monome.light_quadrant(3, FrameFixtures.frame256_3)
      end

      it "should map and rotate a frame in quadrant 4 to quadrant 3 with rotation 90" do
        @comm.should_receive(:illuminate_frame).with(3, FrameFixtures.bit_array256_4_90)
        @monome.light_quadrant(4, FrameFixtures.frame256_4)
      end
    end

    describe "With cable placement left" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "256", :cable_placement => :left)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 1 with rotation 0" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array256_1)
        @monome.light_quadrant(1, FrameFixtures.frame256_1)
      end

      it "should map and rotate a frame in quadrant 2 to quadrant 1 with rotation 0" do
        @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array256_2)
        @monome.light_quadrant(2, FrameFixtures.frame256_2)
      end

      it "should map and rotate a frame in quadrant 3 to quadrant 1 with rotation 0" do
        @comm.should_receive(:illuminate_frame).with(3, FrameFixtures.bit_array256_3)
        @monome.light_quadrant(3, FrameFixtures.frame256_3)
      end

      it "should map and rotate a frame in quadrant 4 to quadrant 1 with rotation 0" do
        @comm.should_receive(:illuminate_frame).with(4, FrameFixtures.bit_array256_4)
        @monome.light_quadrant(4, FrameFixtures.frame256_4)
      end
    end
  end
end
