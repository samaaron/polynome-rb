require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Table do
  it "should resolve to the correct constant from this context" do
    Polynome::Table.should == Table
  end

  describe "#monomes" do
    it "should return an empty array before any monomes have been added" do
      Table.new.send(:monomes).should == []
    end
  end

  describe "apps" do
    it "should return an empty array before any applications have been added" do
      Table.new.send(:apps).should == []
    end
  end

  describe "#connect" do
    describe "erroneously" do
      before(:each) do
        @table = Table.new(:ignore_connection_validity => true)
      end

      it "should complain if the application name isn't registered" do
        lambda{@table.connect(:app => "sooze", :monome => "test64")}.should raise_error(Table::ApplicationNameUnknownError)
      end
    end

    describe "successfully (with default opts)" do
      before(:each) do
        @table = Table.new(:ignore_connection_validity => true)
        @table.add_app(:device => 64,  :name => "app64")
        @table.add_monome(:io_file => 'foo/bar', :device => "64", :cable_placement => :bottom, :name => "test64")
        @table.send(:connections).size.should == 0
        @table.connect(:app => "app64", :monome => "test64")
        @table.send(:connections).size.should == 1
        @connection = @table.send(:connections).first
      end

      it "should register the application on the base surface by default" do
        @connection[:projection].surface.name.should == "base"
      end

      it "should create a default name of the monome/app names if no name is supplied" do
        @connection[:name].should == "test64/app64"
      end

      it "should register the correct application with the surface's projection" do
        app = @connection[:projection].application
        app.name.should == "app64"
      end

      it "should register the rotation of 0 as default" do
        @connection[:projection].rotation.should == 0
      end
    end

    describe "successfully (with a rotation of 90)" do
      before(:each) do
        @table = Table.new(:ignore_connection_validity => true)
        @table.add_app(:device => 64,  :name => "app64")
        @table.add_monome(:io_file => 'foo/bar', :device=> "64", :cable_placement => :bottom, :name => "test64")
        @table.send(:connections).size.should == 0
        @table.connect(:app => "app64", :monome => "test64", :rotation => 90)
        @table.send(:connections).size.should == 1
        @connection = @table.send(:connections).first
      end

      it "should be possible to specify a rotation of 90" do
        @connection[:projection].rotation.should == 90
      end
    end
  end
end


describe "#add_app" do
  describe "successfully adding a 64 and 128 app" do
    before(:each) do
      @table = Table.new(:ignore_connection_validity => true)
      @table.add_app(:device => 64,  :name => "app64")
      @table.add_app(:device => 128, :name => :app128)
    end

    it "should have incremented the number of apps by 2" do
      @table.send(:apps).size.should == 2
    end

    it "should have created the correct 64 app" do
      app = @table.send(:app, :app64)
      app.should_not be_nil
      app.name.should == "app64"
      app.num_quadrants.should == 1
    end

    it "should have created the correct 128 app" do
      app = @table.send(:app, "app128")
      app.should_not be_nil
      app.name.should == "app128"
      app.num_quadrants.should == 2
    end
  end

  describe "when adding two apps with the same name" do
    it "should raise a duplicate app name error" do
      @table = Table.new(:ignore_connection_validity => true)
      lambda{@table.add_app(:device => 64,  :name => "app64")}.should_not raise_error
      lambda{@table.add_app(:device => 128, :name => :app64)}.should raise_error(Rack::ApplicationNameInUseError)
    end
  end



  describe "#add_monome" do
    it "should raise an error if the name already exists" do
      table = Table.new(:ignore_connection_validity => true)
      lambda{table.add_monome(:io_file => 'baz/quux', :device => "64",  :name => "fred")}.should_not raise_error
      lambda{table.add_monome(:io_file => 'foo/bar',  :device => "64",  :name => "fred")}.should raise_error(Table::MonomeNameNotAvailableError)
    end
  end
end

describe "successfully adding a 64 and 128 monome" do
  before(:each) do
    @table = Table.new(:ignore_connection_validity => true)
    @table.add_monome(:io_file => 'foo/bar', :device => "64", :cable_placement => :bottom, :name => "test64")
    @table.add_monome(:io_file => 'baz/quux', :device => "128", :cable_placement => :top, :name => "test128")
  end

  it "increment the number of monomes by 2" do
    @table.send(:monomes).size.should == 2
  end

  it "should have created the correct 64 monome" do
    monome = @table.send(:monome, :test64)
    monome.should_not be_nil
    monome.num_quadrants.should == 1
    monome.cable_placement.should == :bottom
  end

  it "should have created the correct 128 monome" do
    monome = @table.send(:monome, :test128)
    monome.should_not be_nil
    monome.num_quadrants.should == 2
    monome.cable_placement.should == :top
  end
end




