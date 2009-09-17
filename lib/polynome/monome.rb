module Polynome
  class Monome
    def initialize(tty_path, model)
      @monome = MonomeSerial::Monome.new(tty_path, model)
    end

    def num_frames_supported
    end
  end
end
