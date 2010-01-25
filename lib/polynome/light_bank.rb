module Polynome
  class LightBank
    def initialize
      @bank    = [Layer.new]
      @current = 0
    end

    def num_layers
      @bank.size
    end
  end
end
