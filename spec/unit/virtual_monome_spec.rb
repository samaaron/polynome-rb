require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Polynome::VirtualMonome do
  it "should exist" do
    Polynome::VirtualMonome.should_not be_nil
  end
end

describe Polynome::VirtualMonome, ", initialised with defaults" do
  before(:each) do
    @vm = Polynome::VirtualMonome.new
  end

  after(:each) do
    @vm.power_down
  end

  it "should have a cable orientation of :top" do
    @vm.cable_orientation.should  == :top
  end

  it "should be of model :sixty_four" do
    @vm.model.should == :sixty_four
  end
end

describe Polynome::VirtualMonome, ", with bespoke initialisation of cable_orientation bottom and model one_twenty_eight" do
  before(:each) do
    @vm = Polynome::VirtualMonome.new(:cable_orientation => :bottom,
                                      :model             => :one_twenty_eight)
  end

  after(:each) do
    @vm.power_down
  end

  it "should have a cable orientation of :bottom" do
    @vm.cable_orientation.should == :bottom
  end

  it "should be of model :one_twenty_eight" do
    @vm.model.should == :one_twenty_eight
  end

  it "should have a min_x of 1" do
    @vm.min_x.should == 1
  end

  it "should have a min_y of 1" do
    @vm.min_y.should == 1
  end

  it "should have a max_x of 16" do
    @vm.max_x.should == 16
  end

  it "should have a max_y of 8" do
    @vm.max_y.should == 8
  end
end

describe Polynome::VirtualMonome, ", with bespoke initialisation of cable_orientation left and model one_twenty_eight" do
  before(:each) do
    @vm = Polynome::VirtualMonome.new(:cable_orientation => :left,
                                      :model             => :one_twenty_eight)
  end

  after(:each) do
    @vm.power_down
  end

  it "should have a cable orientation of :bottom" do
    @vm.cable_orientation.should == :left
  end

  it "should be of model :one_twenty_eight" do
    @vm.model.should == :one_twenty_eight
  end

  it "should have a min_x of 1" do
    @vm.min_x.should == 1
  end

  it "should have a min_y of 1" do
    @vm.min_y.should == 1
  end

  it "should have a max_x of 8" do
    @vm.max_x.should == 8
  end

  it "should have a max_y of 16" do
    @vm.max_y.should == 16
  end
end

describe Polynome::VirtualMonome, ", with bespoke initialisation of cable_orientation left and model sixty_four" do
  before(:each) do
    @vm = Polynome::VirtualMonome.new(:cable_orientation => :left,
                                      :model             => :sixty_four)
  end

  after(:each) do
    @vm.power_down
  end

  it "should have a cable orientation of :bottom" do
    @vm.cable_orientation.should == :left
  end

  it "should be of model :one_twenty_eight" do
    @vm.model.should == :sixty_four
  end

  it "should have a min_x of 1" do
    @vm.min_x.should == 1
  end

  it "should have a min_y of 1" do
    @vm.min_y.should == 1
  end

  it "should have a max_x of 8" do
    @vm.max_x.should == 8
  end

  it "should have a max_y of 8" do
    @vm.max_y.should == 8
  end
end

describe Polynome::VirtualMonome, ", with bespoke initialisation of cable_orientation left and model two_fifty_six" do
  before(:each) do
    @vm = Polynome::VirtualMonome.new(:cable_orientation => :left,
                                 :model             => :two_fifty_six)
  end

  after(:each) do
    @vm.power_down
  end

  it "should have a cable orientation of :bottom" do
    @vm.cable_orientation.should == :left
  end

  it "should be of model :one_twenty_eight" do
    @vm.model.should == :two_fifty_six
  end

  it "should have a min_x of 1" do
    @vm.min_x.should == 1
  end

  it "should have a min_y of 1" do
    @vm.min_y.should == 1
  end

  it "should have a max_x of 16" do
    @vm.max_x.should == 16
  end

  it "should have a max_y of 16" do
    @vm.max_y.should == 16
  end
end

describe Polynome::VirtualMonome, ", with specified input and output ports" do
  before(:each) do
    @polynome_input_port_num  = 7788
    @polynome_output_port_num = 8877
    @vm = Polynome::VirtualMonome.new(:input_port => @polynome_input_port_num,
                                      :output_port => @polynome_output_port_num)
    @outstream = ""
    @logger = ThreadedLogger::TLogger.new(:tosca, @outstream)
  end

  after(:each) do
    @vm.power_down
    @logger.stop
  end

  it "should have an input port of #{@polynome_input_port_num}" do
    @vm.input_port.should == @polynome_input_port_num
  end

  it "should have an output port of #{@polynome_output_port_num}" do
    @vm.output_port.should == @polynome_output_port_num
  end

  describe "with Tosca sender and receivers" do
    before(:each) do
      @sender   = Tosca::Sender.new(@polynome_input_port_num)
      @receiver = Tosca::Receiver.new(@polynome_output_port_num)
      @vm.power_up
    end

    after(:each) do
      @vm.power_down
    end

    it "should forward all input to the output" do
      message = @receiver.wait_for(1) do
        @sender.send('/a/b/c', 1, 2, 3)
      end

      message.should == [['/a/b/c', [1,2,3]]]
    end
  end
end
