require File.dirname(__FILE__) + '/../spec_helper.rb'

describe MonomeSerial::Monome do
  it "should exist" do
    MonomeSerial::Monome.should_not be_nil
  end

  describe "A default monome" do
    before(:each) do
      MonomeSerial::SerialCommunicator.should_receive(:get_communicator).and_return MonomeSerial::SerialCommunicator::DummyCommunicator.new
      @monome = MonomeSerial::Monome.new('m256-007')
      @comm = @monome.communicator
    end

    describe "sending system calls" do

      it "should send the correct binary string to light all lamps" do
        @comm.should_receive(:write).with(["10010001"])
        @monome.illuminate_all
      end

      it "should send the correct binary string to turn all lamps off" do
        @comm.should_receive(:write).with(["10010000"])
        @monome.extinguish_all
      end

      it "should send the correct binary string to set the brightness to 0" do
        @comm.should_receive(:write).with(["10100000"])
        @monome.brightness = 0
      end

      it "should send the correct binary string to set the brightness to 5" do
        @comm.should_receive(:write).with(["10100101"])
        @monome.brightness = 5
      end

      it "should send the correct binary string to set the brightness to 15" do
        @comm.should_receive(:write).with(["10101111"])
        @monome.brightness = 15
      end

      it "should raise an error if a negative brightness is set" do
        lambda{@monome.brightness = -1}.should raise_error(ArgumentError)
      end

      it "should raise an error if a brightness is set to an integer greater than 15" do
        lambda{@monome.brightness = 16}.should raise_error(ArgumentError)
      end
    end
  end
end
