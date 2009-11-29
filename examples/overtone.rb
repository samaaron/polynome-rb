#add polynome and fixture info to load path
$: << File.dirname(__FILE__) +  "/../lib"
$: << File.dirname(__FILE__) +  "/../spec"

#require polynome and fixtures
require 'polynome'
require 'fixtures/frame_fixtures'

class OvertoneController
  include Polynome

  def initialize
    monome_io_file = "/dev/tty.usbserial-m256-203"
    monome_model   = "256"

    @monome = MonomeSerial::MonomeCommunicator.new(monome_io_file)
  end

  def start
    @thread = Thread.new do
      loop do
        action, x, y = @monome.read
        puts [action, x, y].inspect
      end
    end
  end
end

t = OvertoneController.new.start
t.join

