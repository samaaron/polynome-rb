require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Table do
  it "should resolve to the correct constant from this context" do
    Polynome::Table.should == Table
  end

  describe "#monomes" do
    it "should return an empty array before any monomes have been added" do
      Table.new.monomes.should == []
    end
  end

  describe "apps" do
    it "should return an empty array before any applications have been added" do
      Table.new.apps.should == []
    end
  end


  describe "#add_app" do
    describe "successfully adding a 64 and 128 app" do
      before(:each) do
        @table = Table.new
        @table.add_app(:model => 64,  :name => "app64")
        @table.add_app(:model => 128, :name => :app128)
      end

      it "should have incremented the number of apps by 2" do
        @table.apps.size.should == 2
      end

      it "should have created the correct 64 app" do
        app = @table.app(:app64)
        app.should_not be_nil
        app.name.should == "app64"
        app.num_quadrants.should == 1
      end

      it "should have created the correct 128 app" do
        app = @table.app("app128")
        app.should_not be_nil
        app.name.should == "app128"
        app.num_quadrants.should == 2
      end
    end
  end

  describe "#add_monome" do
    describe "erroneously" do
      it "should raise an error when no name is specified" do
        lambda{Table.new.add_monome(:io_file => 'foo/bar', :model => "64")}.should raise_error(Table::MonomeNameNotSpecifiedError)
      end

      it "should raise an error if the name already exists" do
        table = Table.new
        lambda{table.add_monome(:io_file => 'baz/quux', :model => "64",  :name => "fred")}.should_not raise_error
        lambda{table.add_monome(:io_file => 'foo/bar',  :model => "64",  :name => "fred")}.should raise_error(Table::MonomeNameNotAvailableError)
      end
    end

    describe "successfully adding a 64 and 128 monome" do
      before(:each) do
        @table = Table.new
        @table.add_monome(:io_file => 'foo/bar', :model => "64", :cable_orientation => :bottom, :name => "test64")
        @table.add_monome(:io_file => 'baz/quux', :model => "128", :cable_orientation => :top, :name => "test128")
      end

      it "increment the number of monomes by 2" do
        @table.monomes.size.should == 2
      end

      it "should have created the correct 64 monome" do
        monome = @table.monome(:test64)
        monome.should_not be_nil
        monome.num_quadrants.should == 1
        monome.cable_orientation.should == :bottom
      end

      it "should have created the correct 128 monome" do
        monome = @table.monome(:test128)
        monome.should_not be_nil
        monome.num_quadrants.should == 2
        monome.cable_orientation.should == :top
      end
    end
  end
end


