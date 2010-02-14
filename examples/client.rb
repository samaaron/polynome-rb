#add polynome and fixture info to load path
$: << File.dirname(__FILE__) +  "/../lib"
$: << File.dirname(__FILE__) +  "/../spec"

#pull in polynome for fun & tricks
require 'polynome'
include Polynome

class AllLighter < Client
 def button_pressed(x,y)
   all_lights_on
 end

 def button_released(x,y)
   all_lights_off
 end
end

class Toggler < Client
  def button_pressed(x,y)
    toggle(x,y)
  end
end

class SCFlasher < Client
  def init
    listen(5706, "/tick") {toggle_all}
  end

  def button_pressed(x,y)
    send_to(57120, "/press", (x * 8) + y)
  end
end

class Bouncer < Client
  def init
    @position  = [0] * 8
    @direction = [0] * 8
    @range     = [0] * 8
    @current_column = 0
    listen(5706, "/tick") {bounce_lights_and_prepare_notes}
  end

  def button_pressed(x,y)
    norm_x = x - 1
    norm_y = y - 1
    @range[norm_x]     = norm_y
    @position[norm_x]  = norm_y
    @direction[norm_x] = 1
    [0,1,2,3,4,5,6,7].each{|y_to_clear| light_off(norm_x, y_to_clear)}
  end

  def bounce_lights_and_prepare_notes
    [0,1,2,3,4,5,6,7].each do |col_index|
      @current_column = col_index
      when_bouncing do
        update_position
        prepare_note if reached_bottom?
        turn_off_led_for_previous_position
        turn_on_led_for_current_position
      end
    end
  end

  def prepare_note
    send_to(57120, "/play", @current_column)
  end

  def when_bouncing
    yield if @range[@current_column] != 0
  end

  def turn_on_led_for_current_position
    light_on(@current_column, @position[@current_column])
  end

  def turn_off_led_for_previous_position
    light_off(@current_column, @position[@current_column] - @direction[@current_column])
  end

  def update_position
    reverse_direction if reached_bottom? || reached_top_of_range?
    @position[@current_column] += @direction[@current_column]
  end

  def reverse_direction
    @direction[@current_column] *= -1
  end

  def reached_bottom?
    @position[@current_column] == 0
  end

  def reached_top_of_range?
    @position[@current_column] == @range[@current_column]
  end
end

Bouncer.new








#don't let the fun stop...
loop { sleep 0.1 }
