require File.dirname(__FILE__) + '/../../spec_helper.rb'
include Polynome

describe Monome do

  describe "Given a mocked out monome communicator" do
    before(:each) do
      @comm   = MonomeSerial::MonomeCommunicator.new('foo/bar')
      MonomeSerial::MonomeCommunicator.should_receive(:new).and_return(@comm)
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
  end
end
