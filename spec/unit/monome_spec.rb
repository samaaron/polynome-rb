require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Monome do

  it "should point to the correct constant from this namespace" do
    Monome.should == Polynome::Monome
  end

  describe "#initialize" do
    it "should raise an ArgumentError if an unknown cable placement is specified" do
      lambda{Monome.new(:io_file => 'foo/bar', :device => "256", :cable_placement => "wireless (dream on)")}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no io_file is specified" do
      lambda{Monome.new(:device => "256")}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no device is specified" do
      lambda{Monome.new(:io_file => 'foo/bar')}.should raise_error(ArgumentError)
    end
  end

  describe "with a default Monome of model 256" do
    before(:each) do
      @monome = Monome.new(:io_file => 'foo/bar', :device => "256")
    end

    it "should have a cable placement of top" do
      @monome.cable_placement.should == :top
    end

    it "should have kind TwoFiftySix" do
      @monome.model.should be_kind_of(Model::TwoFiftySix)
    end

    it "should have 4 quadrants" do
      @monome.num_quadrants.should == 4
    end

    it "should start with 1 surface" do
      @monome.carousel.size.should == 1
    end
  end
end
