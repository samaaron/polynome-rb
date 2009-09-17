require File.dirname(__FILE__) + '/../spec_helper.rb'
include MonomeSerial

describe MonomeCommunicator do
  it "should exist" do
    MonomeCommunicator.should_not be_nil
  end

  it "should raise an error when not initializing with a correct protocol name" do
    lambda{MonomeCommunicator.new('/blah', "phonycol" )}.should raise_error(ArgumentError)
  end

  describe "A default monome with an unusual tty_path" do
    before(:each) do
      @monome = MonomeCommunicator.new('unusual_path')
    end

    it "should default to the series protocol" do
      @monome.protocol.should == "series"
    end

    it "should default the serial to Serial Unknown" do
      @monome.serial.should == "Serial Unknown"
    end

    it "should have a dummy communicator" do
      @monome.communicator.class.should == SerialCommunicator::DummyCommunicator
    end
  end

  describe "A default monome with the 40h protocol" do
    before(:each) do
      @monome = MonomeCommunicator.new('/foo/tty.usbserial-m256-203', '40h')
    end

    it "should raise an exception when a communicating method is used" do
      lambda{@monome.illuminate_lamp(0,0)}.should raise_error(NotImplementedError)
    end
  end

  describe "A monome with a normal tty_path and a dummy communicator" do
    before(:each) do
      SerialCommunicator.should_receive(:get_communicator).and_return SerialCommunicator::DummyCommunicator.new
      @monome = MonomeCommunicator.new('/foo/tty.usbserial-m256-203')
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
