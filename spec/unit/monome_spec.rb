require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Monome do
  it "should exist" do
    Monome.should_not be_nil
  end

  describe "with a default Monome" do
    before(:each) do
      @mcom = Monome.new('foo/bar', "256")
    end
  end
end
