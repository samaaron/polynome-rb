require File.dirname(__FILE__) + '/../spec_helper.rb'

describe MonomeSerial::Monome do
  it "should exist" do
    MonomeSerial::Monome.should_not be_nil
  end

  describe "A basic monome with a dummy communicator" do
    before(:each) do
      MonomeSerial::SerialCommunicator.should_receive(:get_communicator).and_return MonomeSerial::SerialCommunicator::DummyCommunicator.new
      @monome = MonomeSerial::Monome.new('blah-m256-007')
      @comm = @monome.communicator
    end

    it "should have a model of 256" do
      @monome.model.should == "256"
    end

    it "should have a serial of 007" do
      @monome.serial.should == "007"
    end

    describe "illuminate_lamp" do
      it "should send the correct binary string to the communicator for coord 0,0" do
        @comm.should_receive(:write).with(["00100000", "00000000"])
        @monome.illuminate_lamp(0,0)
      end

      it "should send the correct binary string to the communicator for coord 15,15" do
        @comm.should_receive(:write).with(["00100000", "11111111"])
        @monome.illuminate_lamp(15, 15)
      end

      it "should send the correct binary string to the communicator for coord 10, 12" do
        @comm.should_receive(:write).with(["00100000", "10101100"])
        @monome.illuminate_lamp(10, 12)
      end
    end

    describe "extinguish_lamp" do
      it "should send the correct binary string to the communicator for coord 0,0" do
        @comm.should_receive(:write).with(["00110000", "00000000"])
        @monome.extinguish_lamp(0,0)
      end

      it "should send the correct binary string to the communicator for coord 15,15" do
        @comm.should_receive(:write).with(["00110000", "11111111"])
        @monome.extinguish_lamp(15, 15)
      end

      it "should send the correct binary string to the communicator for coord 12, 10" do
        @comm.should_receive(:write).with(["00110000", "11001010"])
        @monome.extinguish_lamp(12, 10)
      end
    end
  end
end
