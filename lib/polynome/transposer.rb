module Polynome
  class Transposer
    attr_reader :max_width, :max_height
    attr_writer :orientation


    def initialize(model)
      case model
      when "40h", "64" then init_64
      when "128" then init_128
      when "256" then init_256
      else raise ArgumentError, "Unknown monome type: #{model}"
      end

      @orientation = :top
    end

    def init_64
      @max_width  = 7
      @max_height = 7
    end

    def init_128
      @max_width  = 15
      @max_height = 7
    end

    def init_256
      @max_width  = 15
      @max_height = 15
    end

    def transpose_coords(x, y)
      return y, @max_height - x
    end

    def transpose_col(col)
      @max_height - col
    end

    def transpose_row(row)
      row
    end

    def transpose_row_pattern(pattern)
      pattern.reverse
    end

    def transpose_col_pattern(pattern)
      pattern
    end
  end
end
