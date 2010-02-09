module Polynome
  attr_reader :max_x, :max_y, :name
  class Layer
    def initialize(max_x, max_y, name)
      @max_x  = max_x
      @max_y  = max_y
      @name   = name.to_sym
      @lights = Hash.new(:off)
    end

    def on(x,y)
      @lights[[x,y]] = :on
    end

    def off(x,y)
      @lights[[x,y]] = :off
    end

    def glass(x,y)
      @lights[[x,y]] = :glass
    end

    def toggle(x,y)
      @lights[[x,y]] = opposite(@lights[[x,y]])
    end

    def toggle_all
      current_default = @lights[-1] #a value never used

      inverted_lights = Hash.new(opposite(current_default))
      @lights.each{|coords, state| inverted_lights[coords] = opposite(state)}
      @lights = inverted_lights
    end

    def all_on
      @lights = Hash.new(:on)
    end

    def all_off
      @lights = Hash.new(:off)
    end

    def all_glass
      @lights = Hash.new(:glass)
    end

    def to_frame_string
      #FIXME currently hardcoded for one 64 frame
      #also, perhaps this should be replaced when the LightBank merge
      #strategy is implemented.

      string = ""
      (1..@max_y).to_a.reverse.each do |y|
        (1..@max_x).to_a.each do |x|
          bit = @lights[[x,y]] == :on ? "1 " : "0 "
          string << bit
        end
      end

      index = 0
      8.times do |i|
        puts string[index..(index + 15)]
        index += 16
      end

      string.gsub(/\s*/, '')
    end

    private

    def opposite(state)
      case state
      when :on  then :off
      when :off then :on
      end
    end
  end
end
