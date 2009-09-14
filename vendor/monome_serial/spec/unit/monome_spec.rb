require File.dirname(__FILE__) + '/../spec_helper.rb'

describe MonomeSerial::Monome do
  it "should exist" do
    MonomeSerial::Monome.should_not be_nil
  end

  describe "A default monome" do
    before(:each) do
      @monome = MonomeSerial::Monome.new('m256-007')
    end

    it "should have a default cable orientation of top" do
      @monome.cable_orientation.should == :top
    end

    it "should be possible to specify the orientation" do
      @monome.cable_orientation = :bottom
      @monome.cable_orientation.should == :bottom
    end

    it "should raise an exception if an unknown orientation is specified" do
      lambda{@monome.cable_orientation = :beans}.should raise_error(ArgumentError)
    end
  end

  MMAP_COORDS_256 = {
    [0,0] => {
      :top    => ["00001111"],
      :bottom => ["11110000"],
      :left   => ["00000000"],
      :right  => ["11111111"]
    },

    [15,15] => {
      :top    => ["11110000"],
      :bottom => ["00001111"],
      :left   => ["11111111"],
      :right  => ["00000000"]
    },

    [7,7] => {
      :top    => ["01111000"],
      :bottom => ["10000111"],
      :left   => ["01110111"],
      :right  => ["10001000"]
    },

    [2,9] => {
      :top    => ["10011101"],
      :bottom => ["01100010"],
      :left   => ["00101001"],
      :right  => ["11010110"]
    },

    [10,4] => {
      :top    => ["01000101"],
      :bottom => ["10111010"],
      :left   => ["10100100"],
      :right  => ["01011011"]
    }
  }

  PMAP_COORDS_TO_MMAP_COORDS = {
      #pmap      #mmap
      :top    => :right,
      :bottom => :left,
      :left   => :top,
      :right  => :bottom
  }

  MMAP_ROW_256 = {
    [1,255] => {
      #left to right, 11111111
      :right  => ["01001110", "11111111"],
      :bottom => ["01011110", "11111111"],
      :left   => ["01000001", "11111111"],
      :top    => ["01010001", "11111111"]
    },

    [1,0] => {
      #left to right, 00000000
      :right  => ["01001110", "00000000"],
      :bottom => ["01011110", "00000000"],
      :left   => ["01000001", "00000000"],
      :top    => ["01010001", "00000000"]
    },

    [1,197] => {
      #left to right, 10100011
      :right  => ["01001110", "10100011"],
      :bottom => ["01011110", "11000101"],
      :left   => ["01000001", "11000101"],
      :top    => ["01010001", "10100011"]
    },

    [1, 197, 47] => {
      #left to right, 1010001111110100
      :right  => ["01101110", "11110100", "10100011"],
      :bottom => ["01111110", "11000101", "00101111"],
      :left   => ["01100001", "11000101", "00101111"],
      :top    => ["01110001", "11110100", "10100011"]
    }
  }


  describe "A 256 monome with cable orientation set to top" do
    before(:each) do
      MonomeSerial::SerialCommunicator.should_receive(:get_communicator).and_return MonomeSerial::SerialCommunicator::DummyCommunicator.new
      @monome = MonomeSerial::Monome.new('blah-m256-007')
      @monome.cable_orientation = :top
      @comm = @monome.communicator
    end

    it "should have a cable orientation of top" do
      @monome.cable_orientation.should == :top
    end

    it "should have a model of 256" do
      @monome.model.should == "256"
    end

    it "should have a serial of 007" do
      @monome.serial.should == "007"
    end

    #describe "on" do
    #  it "should send the correct binary string to the communicator for coord 0,0" do
    #    @comm.should_receive(:write).with()
    #    @monome.on(0,0)
    #  end
    #
    #  it "should send the correct binary string to the communicator for coord 15,15" do
    #    @comm.should_receive(:write).with()
    #    @monome.on(15,15)
    #  end
    #
    #  it "should send the correct binary string to the communicator for coord 10, 12" do
    #    @comm.should_receive(:write).with()
    #    @monome.on(7,7)
    #  end
    #end
    #
    #describe "off" do
    #  it "should send the correct binary string to the communicator for coord 0,0" do
    #    @comm.should_receive(:write).with()
    #    @monome.off(0,0)
    #  end
    #
    #  it "should send the correct binary string to the communicator for coord 15,15" do
    #    @comm.should_receive(:write).with()
    #    @monome.extinguish_lamp(15, 15)
    #  end
    #
    #  it "should send the correct binary string to the communicator for coord 12, 10" do
    #    @comm.should_receive(:write).with()
    #    @monome.extinguish_lamp(12, 10)
    #  end
    #end
  end
end
