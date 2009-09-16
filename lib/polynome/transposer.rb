module Polynome
  class Transposer
    attr_writer :orientation

    def initialize(model_string)
      @model = MonomeModel.get_model(model_string)
      @orientation = :top
    end

    def max_width_coord
      @model.width - 1
    end

    def max_height_coord
      @model.height - 1
    end

    def transpose_coords(x, y)
      return y, @max_height_coord - x
    end

    def transpose_col(col)
      @max_height_coord - col
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
