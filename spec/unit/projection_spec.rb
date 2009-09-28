require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe 'sanity check' do
  it "should resolve the constant correctly from this context" do
    Projection.should == Polynome::Projection
  end
end
