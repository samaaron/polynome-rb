require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Application do
  it "should resolve to the correct constant from this context" do
    Application.should == Polynome::Application
  end

  describe "#initialize" do
it "should be possible to initialise an application with a device" do
    lambda{Application.new(:device => '256', :name => "test")}.should_not raise_error
  end

    it "should raise an ArgumentError if no model is specified" do
      lambda{Application.new()}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no name is specified" do
      lambda{Application.new(:device => "256")}.should raise_error(ArgumentError)
    end

    it "should default to an orientation of landscape if one isn't supplied" do
      Application.new(:device => "256", :name => "test").orientation.should == :landscape
    end
  end


  describe "#name" do
    it "should be able to return its name" do
      Application.new(:device=> "64", :name => "foobar").name.should == "foobar"
    end
  end

  describe "#orientation" do
    it "should be able to return its orientation" do
      Application.new(:device =>"128", :name => "barbaz").orientation.should == :landscape
    end
  end


  describe "#num_quadrants" do
    it "should return 1 for a 64 app initialized with a string model name" do
      Application.new(:device => "64", :name => "test").num_quadrants.should == 1
    end

    it "should return 1 for a 64 app initialized with a numeric model name" do
      Application.new(:device => 64, :name => "test").num_quadrants.should == 1
    end

    it "should return 1 for a 40h app" do
      Application.new(:device => "40h", :name => "test").num_quadrants.should == 1
    end

    it "should return 2 for a 128 app initialized with a string model name" do
      Application.new(:device => "128", :name => "test").num_quadrants.should == 2
    end

    it "should return 2 for a 128 app initialized with a numeric model name" do
      Application.new(:device => 128,  :name => "test").num_quadrants.should == 2
    end

    it "should return 4 for a 256 app initialized with a string model name" do
      Application.new(:device => "256", :name => "test").num_quadrants.should == 4
    end


    it "should return 4 for a 256 app initialized with a numeric model name" do
      Application.new(:device => 256, :name => "test").num_quadrants.should == 4
    end
  end

  describe "#update_display" do
    before(:each) do
      @app64  = Application.new(:device => 64, :name => "app64")
      @app128 = Application.new(:device => 128, :name => "app128")
      @app256 = Application.new(:device => 256, :name => "app256")
      @frame  = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
    end

    it "should raise an error if too few frames are sent" do
      lambda{@app64.update_display()}.should raise_error(ArgumentError)
      lambda{@app128.update_display(@frame)}.should raise_error(ArgumentError)
      lambda{@app256.update_display(@frame, @frame, @frame)}.should raise_error(ArgumentError)
    end

    it "should raise an error if too many frames are sent" do
      lambda{@app64.update_display(@frame, @frame)}.should raise_error(ArgumentError)
      lambda{@app128.update_display(@frame, @frame, @frame)}.should raise_error(ArgumentError)
      lambda{@app256.update_display(@frame, @frame, @frame, @frame, @frame)}.should raise_error(ArgumentError)
    end

    it "should not raise an error if the correct number of frames are sent" do
      lambda{@app64.update_display(@frame)}.should_not raise_error
      lambda{@app128.update_display(@frame, @frame)}.should_not raise_error
      lambda{@app256.update_display(@frame, @frame, @frame, @frame)}.should_not raise_error
    end

  end

end
