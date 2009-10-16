require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome
describe "Given a 64 monome and a 64 app registered on its base surface with the default projection" do
  before(:each) do
    @comm   = MonomeSerial::MonomeCommunicator.new('foo/bar', "series")
    MonomeSerial::MonomeCommunicator.should_receive(:new).and_return(@comm)
    @monome    = Monome.new(:io_file => 'foo/bar', :model => "64")
    @app64     = Application.new(:model => 64, :name => "app64")
    @surface   = @monome.fetch_surface(:base)
    @surface.register_application(@app64, :quadrant => 1)
    @frame1    = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
    @frame0    = Frame.new("0000000000000000000000000000000000000000000000000000000000000000")
  end

  it "should pass the frame correctly from application to surface" do
    @comm.should_receive(:illuminate_frame).with(1, @frame1.read)
    @app64.update_display(@frame1)
  end
end
