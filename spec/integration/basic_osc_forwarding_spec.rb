require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Polynome, "forwarding basic Monome OSC messages" do
  before(:each) do
    @sender   = Polynome::TestHelpers::Sender.new
    @receiver = Polynome::TestHelpers::Receiver.new
  end
end
