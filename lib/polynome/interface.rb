module Polynome
  #represents the interface for a monome application
  class Interface
    def initialize(model)
      @model = model
    end

    def num_quadrants
      @model.num_quadrants
    end

    def model_type
      @model.name
    end
  end
end
