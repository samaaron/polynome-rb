require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Application do
  before(:each) {Application.reset_registered_applications!}

  it "should resolve to the correct constant from this context" do
    Application.should == Polynome::Application
  end

  describe "#initialize" do
it "should be possible to initialise an application with a model and an orientation" do
    lambda{Application.new(:model => '256', :name => "test", :orientation => :landscape)}.should_not raise_error
  end

    it "should raise an ArgumentError if an unknown cable orientation is specified" do
      lambda{Application.new(:model => "256",  :name => "test", :orientation => :dreamscape)}.should raise_error(Model::InvalidOrientation)
    end

    it "should raise an ArgumentError if no model is specified" do
      lambda{Application.new()}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no name is specified" do
      lambda{Application.new(:model => "256")}.should raise_error(ArgumentError)
    end

    it "should default to an orientation of landscape if one isn't supplied" do
      Application.new(:model => "256", :name => "test").orientation.should == :landscape
    end

    it "should raise an error if the name specified is already in use" do
      Application.new(:model => "256", :name => "beans")
      lambda{Application.new(:model => "256", :name => "beans")}.should raise_error(Application::NameInUseError)
    end
  end

  describe ".[]" do
    it "should be possible to fetch application instances using the class [] method" do
      adoo = Application.new(:model => '256', :name => "adoo_adoo")
      Application["adoo_adoo"].should == adoo
    end

    it "should raise an application uknown error if no applications match the name given" do
      lambda{Application["unknown_application"]}.should raise_error(Application::UnknownName)
    end
  end

  describe "#name" do
    it "should be able to return its name" do
      Application.new(:model => "64", :name => "foobar").name.should == "foobar"
    end
  end

  describe "#orientation" do
    it "should be able to return its orientation" do
      Application.new(:model =>"128", :name => "barbaz", :orientation => :landscape).orientation.should == :landscape
    end
  end


  describe "#num_quadrants" do
    it "should return 1 for a 64 app initialized with a string model name" do
      Application.new(:model => "64", :name => "test").num_quadrants.should == 1
    end

    it "should return 1 for a 64 app initialized with a numeric model name" do
      Application.new(:model => 64, :name => "test").num_quadrants.should == 1
    end

    it "should return 1 for a 40h app" do
      Application.new(:model => "40h", :name => "test").num_quadrants.should == 1
    end

    it "should return 2 for a 128 app initialized with a string model name" do
      Application.new(:model => "128", :name => "test").num_quadrants.should == 2
    end

    it "should return 2 for a 128 app initialized with a numeric model name" do
      Application.new(:model => 128,  :name => "test").num_quadrants.should == 2
    end

    it "should return 4 for a 256 app initialized with a string model name" do
      Application.new(:model => "256", :name => "test").num_quadrants.should == 4
    end


    it "should return 4 for a 256 app initialized with a numeric model name" do
      Application.new(:model => 256, :name => "test").num_quadrants.should == 4
    end
  end

  describe "#register_projection" do
    before(:each) do
      @app64 = Application.new(:model => 64, :name => "test")
      @monome = Monome.new(:io_file => "blah", :model => "256", :cable_orientation => :top)
      @surface = Surface.new("surf", 4, @monome)
      @projection = Projection.new(@surface, @app64, 0, Quadrants.new([1]))
    end

    it "should be possible to register a projection" do
      lambda{@app64.projection = @projection}.should_not raise_error
    end

    it "should be possible to get a registered projection" do
      @app64.projection = @projection
      @app64.projection.should == @projection
    end
  end
end
