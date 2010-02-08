#add polynome and fixture info to load path
$: << File.dirname(__FILE__) +  "/../lib"
$: << File.dirname(__FILE__) +  "/../spec"

#pull in polynome for fun & tricks
require 'polynome'
include Polynome

class Lighter < Client
  def button_pressed(x,y)
    light_on(x,y)
  end

  def button_released(x,y)
    light_off(x,y)
  end
end

class Toggler < Client
  def button_pressed(x,y)
    toggle(x,y)
  end
end

class SCFlasher < Client
  def init
    puts 'hiya'
    log "***", "fooo"
    @listener = OSCListener.new(5706)
    @listener.add_method("/flash", nil) {toggle(1,1)}
    @listener.start
  end
end

SCFlasher.new








#don't let the fun stop...
loop { sleep 0.1 }
