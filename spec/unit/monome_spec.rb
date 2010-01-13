require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Monome do

  it "should point to the correct constant from this namespace" do
    Monome.should == Polynome::Monome
  end

  describe "#initialize" do
    it "should raise an ArgumentError if an unknown cable placement is specified" do
      lambda{Monome.new(:io_file => 'foo/bar', :device => "256", :cable_placement => "wireless (dream on)")}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no io_file is specified" do
      lambda{Monome.new(:device => "256")}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no device is specified" do
      lambda{Monome.new(:io_file => 'foo/bar')}.should raise_error(ArgumentError)
    end
  end

  describe "with a default Monome of model 256" do
    before(:each) do
      @monome = Monome.new(:io_file => 'foo/bar', :device => "256")
    end

    it "should have a cable placement of top" do
      @monome.cable_placement.should == :top
    end

    it "should have kind TwoFiftySix" do
      @monome.model.should be_kind_of(Model::TwoFiftySix)
    end

    it "should have 4 quadrants" do
      @monome.num_quadrants.should == 4
    end

    it "should start with 1 surface" do
      @monome.carousel.size.should == 1
    end
  end

  describe "Given a mocked out monome communicator" do
    before(:each) do
      @comm   = MonomeSerial::MonomeCommunicator.new('foo/bar', "series")
      MonomeSerial::MonomeCommunicator.should_receive(:new).and_return(@comm)
    end

    describe "With a 256 with cable placment top" do
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

    describe "With a 256 with cable placement right" do
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

    describe "With a 256 with cable placement bottom" do
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

    describe "With a 256 with cable placement left" do
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

    describe "With a 64 with cable placment top" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "64", :cable_placement => :top)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 1 with rotation 0" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64)
        @monome.light_quadrant(1, FrameFixtures.frame64)
      end

      describe "Receiving button presses" do
        it "should know that a button press of 1,1 is in quadrant 1" do
          @monome.button_quadrant(1,1).should == 1
        end

        it "should know that a button press of 6,6 is in quadrant 1" do
          @monome.button_quadrant(6,6).should == 1
        end

        it "should know that a button press of 8,8 is in quadrant 1" do
          @monome.button_quadrant(8,8).should == 1
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(9,3)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(3,9)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
        end
      end
    end

    describe "With a 64 with cable placement right" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "64", :cable_placement => :right)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 1 with rotation 270" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64_270)
        @monome.light_quadrant(1, FrameFixtures.frame64)
      end

      describe "Receiving button presses" do
        it "should know that a button press of 1,1 is in quadrant 1" do
          @monome.button_quadrant(1,1).should == 1
        end

        it "should know that a button press of 6,6 is in quadrant 1" do
          @monome.button_quadrant(6,6).should == 1
        end

        it "should know that a button press of 8,8 is in quadrant 1" do
          @monome.button_quadrant(8,8).should == 1
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(9,3)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(3,9)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
        end
      end
    end

    describe "With a 64 with cable placement bottom" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "64", :cable_placement => :bottom)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 1 with rotation 180" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64_180)
        @monome.light_quadrant(1, FrameFixtures.frame64)
      end

      describe "Receiving button presses" do
        it "should know that a button press of 1,1 is in quadrant 1" do
          @monome.button_quadrant(1,1).should == 1
        end

        it "should know that a button press of 6,6 is in quadrant 1" do
          @monome.button_quadrant(6,6).should == 1
        end

        it "should know that a button press of 8,8 is in quadrant 1" do
          @monome.button_quadrant(8,8).should == 1
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(9,3)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(3,9)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
        end
      end
    end

    describe "With a 64 with cable placement left" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "64", :cable_placement => :left)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 1 with rotation 90" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array64_90)
        @monome.light_quadrant(1, FrameFixtures.frame64)
      end

      describe "Receiving button presses" do
        it "should know that a button press of 1,1 is in quadrant 1" do
          @monome.button_quadrant(1,1).should == 1
        end

        it "should know that a button press of 6,6 is in quadrant 1" do
          @monome.button_quadrant(6,6).should == 1
        end

        it "should know that a button press of 8,8 is in quadrant 1" do
          @monome.button_quadrant(8,8).should == 1
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(9,3)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(3,9)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
        end
      end
    end

    describe "With a 128 with cable placment top" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "128", :cable_placement => :top)
      end

      describe "Illumniation" do
        it "should map and rotate a frame in quadrant 1 to quadrant 1 with rotation 0" do
          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array128_1)
          @monome.light_quadrant(1, FrameFixtures.frame128_1)
        end


        it "should map and rotate a frame in quadrant 2 to quadrant 2 with rotation 0" do
          @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array128_2)
          @monome.light_quadrant(2, FrameFixtures.frame128_2)
        end
      end

      describe "Receiving button presses" do
        it "should know that a button press of 1,1 is in quadrant 1" do
          @monome.button_quadrant(1,1).should == 1
        end

        it "should know that a button press of 6,6 is in quadrant 1" do
          @monome.button_quadrant(6,6).should == 1
        end

        it "should know that a button press of 9,8 is in quadrant 2" do
          @monome.button_quadrant(9,8).should == 2
        end

        it "should know that a button press of 16,8 is in quadrant 1" do
          @monome.button_quadrant(16,8).should == 2
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(17,8)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(15,9)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
        end
      end
    end

    describe "With a 128 with cable placement bottom" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "128", :cable_placement => :bottom)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 2 with rotation 180" do
        @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array128_1_180)
        @monome.light_quadrant(1, FrameFixtures.frame128_1)
      end

      it "should map and rotate a frame in quadrant 2 to quadrant 1 with rotation 180" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array128_2_180)
        @monome.light_quadrant(2, FrameFixtures.frame128_2)
      end

      describe "Receiving button presses" do
        it "should know that a button press of 1,1 is in quadrant 2" do
          @monome.button_quadrant(1,1).should == 2
        end

        it "should know that a button press of 6,6 is in quadrant 2" do
          @monome.button_quadrant(6,6).should == 2
        end

        it "should know that a button press of 9,7 is in quadrant 1" do
          @monome.button_quadrant(9,7).should == 1
        end

        it "should know that a button press of 16,8 is in quadrant 1" do
          @monome.button_quadrant(16,8).should == 1
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(17,8)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(15,9)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
        end
      end
    end

    describe "With a 128 with cable placement left" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "128", :cable_placement => :left)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 2 with rotation 90" do
        @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array128_1_90)
        @monome.light_quadrant(1, FrameFixtures.frame128_1)
      end

      it "should map and rotate a frame in quadrant 2 to quadrant 1 with rotation 90" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array128_2_90)
        @monome.light_quadrant(2, FrameFixtures.frame128_2)
      end

      describe "Receiving button presses" do
        it "should know that a button press of 1,1 is in quadrant 2" do
          @monome.button_quadrant(1,1).should == 2
        end

        it "should know that a button press of 6,6 is in quadrant 2" do
          @monome.button_quadrant(6,6).should == 2
        end

        it "should know that a button press of 9,8 is in quadrant 1" do
          @monome.button_quadrant(9,8).should == 1
        end

        it "should know that a button press of 16,8 is in quadrant 1" do
          @monome.button_quadrant(16,8).should == 1
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(9,16)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(8,17)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
        end
      end
    end

    describe "With a 128 with cable placment right" do
      before(:each) do
        @monome = Monome.new(:io_file => 'foo/bar', :device => "128", :cable_placement => :right)
      end

      it "should map and rotate a frame in quadrant 1 to quadrant 1 with rotation 270" do
        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array128_1_270)
        @monome.light_quadrant(1, FrameFixtures.frame128_1)
      end

      it "should map and rotate a frame in quadrant 2 to quadrant 2 with rotation 270" do
        @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array128_2_270)
        @monome.light_quadrant(2, FrameFixtures.frame128_2)
      end

      describe "Receiving button presses" do
        it "should know that a button press of 1,1 is in quadrant 1" do
          @monome.button_quadrant(1,1).should == 1
        end

        it "should know that a button press of 6,6 is in quadrant 1" do
          @monome.button_quadrant(6,6).should == 1
        end

        it "should know that a button press of 9,8 is in quadrant 2" do
          @monome.button_quadrant(9,8).should == 2
        end

        it "should know that a button press of 15,7 is in quadrant 1" do
          @monome.button_quadrant(15,7).should == 2
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(17,4)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(4,9)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
        end

        it "should raise an error if the coords are out of bounds" do
          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
        end
      end
    end
  end
end
