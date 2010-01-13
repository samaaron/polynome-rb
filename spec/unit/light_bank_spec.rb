require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe LightBank do
  it "should exist" do
    LightBank.should_not be_nil
  end
end

describe LightBank, ", initialised with defaults" do
  before(:each) do
    @bank = LightBank.new
  end

  after(:each) do
    @bank.power_down
  end

  it "should have a cable placement of :top" do
    @bank.cable_placement.should  == :top
  end

  it "should be of model :sixty_four" do
    @bank.model.should == :sixty_four
  end
end

describe LightBank, ", with bespoke initialisation of cable_placement bottom and model one_twenty_eight" do
  before(:each) do
    @bank = LightBank.new(:cable_placement => :bottom,
                          :model             => :one_twenty_eight)
  end

  after(:each) do
    @bank.power_down
  end

  it "should have a cable placement of :bottom" do
    @bank.cable_placement.should == :bottom
  end

  it "should be of model :one_twenty_eight" do
    @bank.model.should == :one_twenty_eight
  end

  it "should have a min_x of 1" do
    @bank.min_x.should == 1
  end

  it "should have a min_y of 1" do
    @bank.min_y.should == 1
  end

  it "should have a max_x of 16" do
    @bank.max_x.should == 16
  end

  it "should have a max_y of 8" do
    @bank.max_y.should == 8
  end
end

describe LightBank, ", with bespoke initialisation of cable_placement left and model one_twenty_eight" do
  before(:each) do
    @bank = LightBank.new(:cable_placement => :left,
                          :model             => :one_twenty_eight)
  end

  after(:each) do
    @bank.power_down
  end

  it "should have a cable placement of :bottom" do
    @bank.cable_placement.should == :left
  end

  it "should be of model :one_twenty_eight" do
    @bank.model.should == :one_twenty_eight
  end

  it "should have a min_x of 1" do
    @bank.min_x.should == 1
  end

  it "should have a min_y of 1" do
    @bank.min_y.should == 1
  end

  it "should have a max_x of 8" do
    @bank.max_x.should == 8
  end

  it "should have a max_y of 16" do
    @bank.max_y.should == 16
  end
end

describe LightBank, ", with bespoke initialisation of cable_placement left and model sixty_four" do
  before(:each) do
    @bank = LightBank.new(:cable_placement => :left,
                          :model             => :sixty_four)
  end

  after(:each) do
    @bank.power_down
  end

  it "should have a cable placement of :bottom" do
    @bank.cable_placement.should == :left
  end

  it "should be of model :one_twenty_eight" do
    @bank.model.should == :sixty_four
  end

  it "should have a min_x of 1" do
    @bank.min_x.should == 1
  end

  it "should have a min_y of 1" do
    @bank.min_y.should == 1
  end

  it "should have a max_x of 8" do
    @bank.max_x.should == 8
  end

  it "should have a max_y of 8" do
    @bank.max_y.should == 8
  end
end

describe LightBank, ", with bespoke initialisation of cable_placement left and model two_fifty_six" do
  before(:each) do
    @bank = LightBank.new(:cable_placement => :left,
                          :model             => :two_fifty_six)
  end

  after(:each) do
    @bank.power_down
  end

  it "should have a cable placement of :bottom" do
    @bank.cable_placement.should == :left
  end

  it "should be of model :one_twenty_eight" do
    @bank.model.should == :two_fifty_six
  end

  it "should have a min_x of 1" do
    @bank.min_x.should == 1
  end

  it "should have a min_y of 1" do
    @bank.min_y.should == 1
  end

  it "should have a max_x of 16" do
    @bank.max_x.should == 16
  end

  it "should have a max_y of 16" do
    @bank.max_y.should == 16
  end
end

describe LightBank, ", with specified input and output ports" do
  before(:each) do
    @polynome_input_port_num  = 7788
    @polynome_output_port_num = 8877
    @bank = LightBank.new(:input_port => @polynome_input_port_num,
                          :output_port => @polynome_output_port_num)
    @outstream = ""
    @logger = ThreadedLogger::TLogger.new(:tosca, @outstream)
  end

  after(:each) do
    @bank.power_down
    @logger.stop
  end

  it "should have an input port of #{@polynome_input_port_num}" do
    @bank.input_port.should == @polynome_input_port_num
  end

  it "should have an output port of #{@polynome_output_port_num}" do
    @bank.output_port.should == @polynome_output_port_num
  end

  describe "with Tosca sender and receivers" do
    before(:each) do
      @sender   = Tosca::Sender.new(@polynome_input_port_num)
      @receiver = Tosca::Receiver.new(@polynome_output_port_num)
      @bank.power_up
    end

    after(:each) do
      @bank.power_down
    end

    it "should forward all input to the output" do
      message = @receiver.wait_for(1) do
        @sender.send('/a/b/c', 1, 2, 3)
      end

      message.should == [['/a/b/c', [1,2,3]]]
    end
  end
end
