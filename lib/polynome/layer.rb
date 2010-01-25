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
      puts "toggle: #{x}, #{y}"

      case @lights[[x,y]]
      when :on then @lights[[x,y]] = :off
      when :off then @lights[[x,y]] = :on
      end
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
  end
end
