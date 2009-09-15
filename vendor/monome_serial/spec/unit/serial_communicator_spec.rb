require File.dirname(__FILE__) + '/../spec_helper.rb'
include MonomeSerial

describe SerialCommunicator do
  it "should exist" do
    SerialCommunicator.should_not be_nil
  end

  describe "A dummy serial connection" do
    before(:each) do
      @comm = SerialCommunicator.get_communicator("fake", false)
    end

    it "should be a dummy connection" do
      @comm.should_not be_real
    end

    describe "read" do
      it "should raise an ArgumentError if a non-array-like collection is passed as an argument" do
        lambda{@comm.read(1)}.should raise_error ArgumentError
      end
    end
  end
end
