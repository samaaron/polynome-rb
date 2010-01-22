#require File.dirname(__FILE__) + '/../../spec_helper.rb'
#include Polynome
#
#describe Monome do
#
#  it "should point to the correct constant from this namespace" do
#    Monome.should == Polynome::Monome
#  end
#
#  describe "Given a mocked out monome communicator" do
#    before(:each) do
#      @comm   = MonomeSerial::MonomeCommunicator.new('foo/bar')
#      MonomeSerial::MonomeCommunicator.should_receive(:new).and_return(@comm)
#    end
#
#    describe "With a 128 with cable placment top" do
#      before(:each) do
#        @monome = Monome.new(:io_file => 'foo/bar', :device => "128", :cable_placement => :top)
#      end
#
#      describe "Illumination" do
#        it "should map and rotate a frame in quadrant 1 to quadrant 1 with rotation 0" do
#          @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array128_1)
#          @monome.light_quadrant(1, FrameFixtures.frame128_1)
#        end
#
#
#        it "should map and rotate a frame in quadrant 2 to quadrant 2 with rotation 0" do
#          @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array128_2)
#          @monome.light_quadrant(2, FrameFixtures.frame128_2)
#        end
#      end
#
#      describe "Receiving button presses" do
#        it "should know that a button press of 1,1 is in quadrant 1" do
#          @monome.button_quadrant(1,1).should == 1
#        end
#
#        it "should know that a button press of 6,6 is in quadrant 1" do
#          @monome.button_quadrant(6,6).should == 1
#        end
#
#        it "should know that a button press of 9,8 is in quadrant 2" do
#          @monome.button_quadrant(9,8).should == 2
#        end
#
#        it "should know that a button press of 16,8 is in quadrant 1" do
#          @monome.button_quadrant(16,8).should == 2
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(17,8)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(15,9)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
#        end
#      end
#    end
#
#    describe "With a 128 with cable placement bottom" do
#      before(:each) do
#        @monome = Monome.new(:io_file => 'foo/bar', :device => "128", :cable_placement => :bottom)
#      end
#
#      it "should map and rotate a frame in quadrant 1 to quadrant 2 with rotation 180" do
#        @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array128_1_180)
#        @monome.light_quadrant(1, FrameFixtures.frame128_1)
#      end
#
#      it "should map and rotate a frame in quadrant 2 to quadrant 1 with rotation 180" do
#        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array128_2_180)
#        @monome.light_quadrant(2, FrameFixtures.frame128_2)
#      end
#
#      describe "Receiving button presses" do
#        it "should know that a button press of 1,1 is in quadrant 2" do
#          @monome.button_quadrant(1,1).should == 2
#        end
#
#        it "should know that a button press of 6,6 is in quadrant 2" do
#          @monome.button_quadrant(6,6).should == 2
#        end
#
#        it "should know that a button press of 9,7 is in quadrant 1" do
#          @monome.button_quadrant(9,7).should == 1
#        end
#
#        it "should know that a button press of 16,8 is in quadrant 1" do
#          @monome.button_quadrant(16,8).should == 1
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(17,8)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(15,9)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
#        end
#      end
#    end
#
#    describe "With a 128 with cable placement left" do
#      before(:each) do
#        @monome = Monome.new(:io_file => 'foo/bar', :device => "128", :cable_placement => :left)
#      end
#
#      it "should map and rotate a frame in quadrant 1 to quadrant 2 with rotation 90" do
#        @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array128_1_90)
#        @monome.light_quadrant(1, FrameFixtures.frame128_1)
#      end
#
#      it "should map and rotate a frame in quadrant 2 to quadrant 1 with rotation 90" do
#        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array128_2_90)
#        @monome.light_quadrant(2, FrameFixtures.frame128_2)
#      end
#
#      describe "Receiving button presses" do
#        it "should know that a button press of 1,1 is in quadrant 2" do
#          @monome.button_quadrant(1,1).should == 2
#        end
#
#        it "should know that a button press of 6,6 is in quadrant 2" do
#          @monome.button_quadrant(6,6).should == 2
#        end
#
#        it "should know that a button press of 8,9 is in quadrant 1" do
#          @monome.button_quadrant(8,9).should == 1
#        end
#
#        it "should know that a button press of 8,16 is in quadrant 1" do
#          @monome.button_quadrant(8,16).should == 1
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(9,16)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(8,17)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
#        end
#      end
#    end
#
#    describe "With a 128 with cable placment right" do
#      before(:each) do
#        @monome = Monome.new(:io_file => 'foo/bar', :device => "128", :cable_placement => :right)
#      end
#
#      it "should map and rotate a frame in quadrant 1 to quadrant 1 with rotation 270" do
#        @comm.should_receive(:illuminate_frame).with(1, FrameFixtures.bit_array128_1_270)
#        @monome.light_quadrant(1, FrameFixtures.frame128_1)
#      end
#
#      it "should map and rotate a frame in quadrant 2 to quadrant 2 with rotation 270" do
#        @comm.should_receive(:illuminate_frame).with(2, FrameFixtures.bit_array128_2_270)
#        @monome.light_quadrant(2, FrameFixtures.frame128_2)
#      end
#
#      describe "Receiving button presses" do
#        it "should know that a button press of 1,1 is in quadrant 1" do
#          @monome.button_quadrant(1,1).should == 1
#        end
#
#        it "should know that a button press of 6,6 is in quadrant 1" do
#          @monome.button_quadrant(6,6).should == 1
#        end
#
#        it "should know that a button press of 8,8 is in quadrant 2" do
#          @monome.button_quadrant(8,9).should == 2
#        end
#
#        it "should know that a button press of 7,15 is in quadrant 1" do
#          @monome.button_quadrant(7,15).should == 2
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(9,4)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(4,19)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(-1,2)}.should raise_error(Model::InvalidButtonCoord)
#        end
#
#        it "should raise an error if the coords are out of bounds" do
#          lambda{@monome.button_quadrant(2,-1)}.should raise_error(Model::InvalidButtonCoord)
#        end
#      end
#    end
#  end
#end
