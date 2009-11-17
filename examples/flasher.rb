#add polynome and fixture info to load path
$: << File.dirname(__FILE__) +  "/../lib"
$: << File.dirname(__FILE__) +  "/../spec"

#require polynome and fixtures
require 'polynome'
require 'fixtures/frame_fixtures'

include Polynome

#update these to match your monome's settings
monome_io_file = "/dev/tty.usbserial-m128-115"
monome_model   = "128"

#create table and add monome
table   = Table.new
table.add_monome(:io_file => monome_io_file, :model => monome_model, :cable_orientation => :bottom)

#add flashing app
table.add_app(:model => 64, :name => "app64")
table.connect(:app => "app64", :quadrant => 1)
app64  = table.send(:app, "app64")

#add spinning app
table.add_app(:model => 64, :name => "rotator")
table.connect(:app => "rotator", :quadrant => 2)
rotator = table.send(:app, "rotator")

#logic for flashing app
t1 = Thread.new do
  loop do
    app64.update_display(FrameFixtures.frame64)
    app64.update_display(FrameFixtures.blank)
    sleep 0.1
  end
end

#logic for spinning app
t2 = Thread.new do
  sleep_time = 0.01
  loop do

    sleep_time = 0.01 if sleep_time > 0.5
    sleep_time *= 2

    rotator.update_display(FrameFixtures.frame64)
    sleep sleep_time
    rotator.update_display(FrameFixtures.frame64_90)
    sleep sleep_time
    rotator.update_display(FrameFixtures.frame64_180)
    sleep sleep_time
    rotator.update_display(FrameFixtures.frame64_270)
    sleep sleep_time
  end
end

#output status of queue
t3 = Thread.new do
  loop do
    puts "Num frames queued up to be viewed: #{table.send(:frame_buffer_size)}"
    sleep 3
  end
end

#Go! Go! Go!
table.start
puts "All systems go!\n"

#don't exit process prematurely...
t1.join
