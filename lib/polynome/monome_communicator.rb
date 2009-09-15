module Polynome
  class MonomeCommunicator
    def initialize
      @monomes = []
    end

    def register_monome(tty_path, protocol="series")
      @monomes << MonomeSerial::Monome.new(tty_path, protocol)
    end

    def num_monomes
      @monomes.size
    end
  end
end
