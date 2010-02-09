module Polynome
  class LightBank
    def initialize(max_x, max_y)
      @max_x   = max_x
      @max_y   = max_y
      @layers    = [Layer.new(@max_x, @max_y, :base)]
      @current = 0
    end

    def num_layers
      @layers.size
    end

    def current_layer
      @layers[@current]
    end

    def fetch_layer(layer)
      layer ||= :current

      case layer
      when :current then current_layer
      when Fixnum then @layers[layer]
      when String then @layers.find{|l| l.name == layer.to_sym}
      when Symbol then @layers.find{|l| l.name == layer}
      end
    end

    def on(x, y, opts={})
      fetch_layer(opts[:layer]).on(x,y)
    end

    def off(x, y, opts={})
      fetch_layer(opts[:layer]).off(x,y)
    end

    def toggle(x, y, opts={})
      fetch_layer(opts[:layer]).toggle(x,y)
    end

    def toggle_all(opts={})
      fetch_layer(opts[:layer]).toggle_all
    end

    def all_on(opts={})
      fetch_layer(opts[:layer]).all_on
    end

    def all_off(opts={})
      fetch_layer(opts[:layer]).all_off
    end

    def all_glass(opts={})
      fetch_layer(opts[:layer]).all_glass
    end

    def glass(x, y, opts={})
      fetch_layer(opts[:layer]).glass(x,y)
    end

    def to_frame
      #TODO implement a layer merging strategy here
      Frame.new(current_layer.to_frame_string)
    end
  end
end
