require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Monome do

  it "should point to the correct constant from this namespace" do
    Monome.should == Polynome::Monome
  end

  it "should raise an ArgumentError if an unknown cable orientation is specified" do
    lambda{Monome.new(:io_file => 'foo/bar', :model => "256", :cable_orientation => "wireless (dream on)")}.should raise_error(ArgumentError)
  end

  it "should raise an ArgumentError if no io_file is specified" do
    lambda{Monome.new(:model => "256")}.should raise_error(ArgumentError)
  end

  it "should raise an ArgumentError if no model is specified" do
    lambda{Monome.new(:io_file => 'foo/bar')}.should raise_error(ArgumentError)
  end

  describe "with a default Monome of model 256" do
    before(:each) do
      @monome = Monome.new(:io_file => 'foo/bar', :model => "256")
    end

    it "should have a cable orientation of top" do
      @monome.cable_orientation.should == :top
    end

    it "should have kind TwoFiftySix" do
      @monome.model.should be_kind_of(TwoFiftySix)
    end

    it "should have 4 frame buffers" do
      @monome.num_frame_buffers.should == 4
    end

    it "should start with 0 surfaces" do
      @monome.num_surfaces.should == 0
    end
  end

  describe "with a 64 with a mocked out serial communicator" do
    before(:each) do
      @serial = MonomeSerial::SerialCommunicator::DummyCommunicator.new
      MonomeSerial::SerialCommunicator.should_receive(:get_communicator).and_return(@serial)
      @monome = Monome.new(:io_file => 'foo/bar', :model => "64")
    end

    it "should have 1 frame buffer" do
      @monome.num_frame_buffers.should == 1
    end

    describe "#update_display" do
      describe "with a frame containing all 1s" do
        before do
          @frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        end

        it "should send the contents of the frame buffer to the serial communicator"

      end
    end
  end
end
