#add polynome and fixture info to load path
$: << File.dirname(__FILE__) +  "/../lib"
$: << File.dirname(__FILE__) +  "/../spec"

#require polynome and fixtures
require 'polynome'
require 'fixtures/frame_fixtures'



include Polynome

class App < Application
  def init
    puts 'initializing'
    @frame = FrameFixtures.frame64
  end

  def racked
    update_display(@frame)
  end

  def button_pressed(x,y)
  end

  def button_released(x,y)
    @frame.rotate!(90)
    update_display(@frame)
  end
end


#update these to match your monome's settings
#monome_io_file = "/dev/tty.usbserial-m128-115"
#monome_model   = "128"
monome_io_file = "/dev/tty.usbserial-m64-0790"
monome_device   = "64"

#create table and add monome
table   = Table.new
table.add_monome(:io_file => monome_io_file, :device => monome_device, :cable_placement => :top)

#add flashing app
table.add_app(App, :device => 64, :name => "app64")
table.connect(:app => "app64", :quadrant => 1, :rotation => 0)
app64  = table.send(:app, "app64")

monome = table.send(:monome)
monome.add_app(app64)

#Go! Go! Go!
table.start
puts "All systems go!\n"

#don't exit process prematurely...

t1 = Thread.new do
  loop do
    sleep 0.01
  end
end

t1.join
