#add polynome and fixture info to load path
$: << File.dirname(__FILE__) +  "/../lib"
$: << File.dirname(__FILE__) +  "/../spec"

#pull in polynome for fun & tricks
require 'polynome'
include Polynome

#class AllLighter < Client
# def button_pressed(x,y)
#   all_lights_on
# end
#
# def button_released(x,y)
#   all_lights_off
# end
#end

class Toggler < Client
  def button_pressed(x,y)
    toggle(x,y)
  end
end

#class SCFlasher < Client
#  def init
#    listen(5706, "/tick") {toggle_all}
#  end
#
#  def button_pressed(x,y)
#    send_to(57120, "/press", (x * 8) + y)
#  end
#end

Toggler.new








#don't let the fun stop...
loop { sleep 0.1 }
