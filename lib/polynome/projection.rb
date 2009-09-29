module Polynome
  class Projection
    VALID_ROTATIONS = [0, 90, 180, 270]

    attr_reader :app, :rotation, :quadrants
    def initialize(application, rotation, quadrants)
      raise ArgumentError, "Invalid rotation #{rotation}, expected #{VALID_ROTATIONS.to_sentence :last_word_connector => ' or'}." unless VALID_ROTATIONS.include?(rotation)
      raise ArgumentError, "Quadrants should be of kind Quadrants, not #{quadrants.class}" unless quadrants.kind_of?(Quadrants)

      @app       = application
      @rotation  = rotation
      @quadrants = quadrants
    end
  end
end
