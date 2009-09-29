module Polynome
  class Quadrants

    #Quadrant naming scheme:
    #
    #256
    # + - - - - - - - - +
    # |        |        |
    # |   1    |   2    |
    # |        |        |
    # |        |        |
    # + - - - - - - - - +
    # |        |        |
    # |        |        |
    # |   3    |   4    |
    # |        |        |
    # + - - - - - - - - +

    #128
    # + - - - - - - - - +
    # |        |        |
    # |   1    |   2    |
    # |        |        |
    # |        |        |
    # + - - - - - - - - +

    #64/40h
    # + - - - - +
    # |         |
    # |   1     |
    # |         |
    # |         |
    # + - - - - +

    class QuadrantCountError < StandardError
    end

    class QuadrantIDError < StandardError
    end

    class QuadrantCombinationError < StandardError
    end


    VALID_QUADRANT_COMBINATIONS = {
      1 => [[1], [2], [3], [4]],         # one-quadrant variations
      2 => [[1,2], [1,3], [2,4], [3,4]], # two-quadrant variations
      4 => [[1,2,3,4]]                   # four-quadrant variations
    }

    VALID_QUADRANT_IDS    = [1,2,3,4]
    VALID_QUADRANT_COUNTS = [1,2,4]

    def self.valid_quadrant_id?(id)
      VALID_QUADRANT_IDS.include?(id)
    end

    def self.valid_quadrant_count?(count)
      VALID_QUADRANT_COUNTS.include?(count)
    end

    def self.list_valid_quadrant_counts
      VALID_QUADRANT_COUNTS.join(', ')
    end

    def self.list_valid_quadrant_ids
      VALID_QUADRANT_IDS.join(', ')
    end

    def self.get_valid_quadrants(count)
      raise QuadrantCountError, "Invalid quadrant count" unless valid_quadrant_count?(count)

      VALID_QUADRANT_COMBINATIONS[count].map{|combo| new(combo)}
    end

    attr_reader :count, :ids

    def initialize(quadrant_ids)
      raise QuadrantCountError, "Too many quadrants specified. Expected 1, 2 or 4, got #{quadrant_ids.size}" if quadrant_ids.size < 1 || quadrant_ids.size > 4 || quadrant_ids.size == 3
      quadrant_ids.each{|id| raise QuadrantIDError, "Unknown quadrant id. Expected one of (#{self.class.list_valid_quadrant_ids}), got #{id}" unless self.class.valid_quadrant_id?(id)}

      sorted_quadrant_ids = quadrant_ids.sort
      raise QuadrantCombinationError, "Invalid quadrant combination. Got #{sorted_quadrant_ids.inspect}, expected one of #{all_valid_quadrant_combinations.inspect}" unless valid_quadrant_combination?(sorted_quadrant_ids)

      @count = sorted_quadrant_ids.size
      @ids   = sorted_quadrant_ids
    end

    def ==(other)
      other.kind_of?(Quadrants) &&
      @ids == other.ids
    end

    private

    def all_valid_quadrant_combinations
      VALID_QUADRANT_COMBINATIONS.values.flatten(1)
    end

    def valid_quadrant_combination?(combination)
      all_valid_quadrant_combinations.include?(combination)
    end
  end
end
