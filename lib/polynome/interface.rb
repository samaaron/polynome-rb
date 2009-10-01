module Polynome
  #represents the interface for a monome application
  class Interface
    def initialize(model)
      unless model.kind_of?(Model) then raise ArgumentError,
                                   "Expecting a Model, got a #{model.class}"
      end

      @model = model
    end

    def set_quadrant(quadrant_id, frame)
      if quadrant_id < 1 || quadrant_id > @num_quadrants then raise ArgumentError,
                                   "Quadrant ID out of bounds. Expected something "     +
                                   "in the range #{(1..@num_quadrants).to_a.inspect}, " +
                                   "got #{quadrant_id}."
      end
    end

    def num_quadrants
      @model.num_quadrants
    end

    def model_type
      @model.name
    end
  end
end
