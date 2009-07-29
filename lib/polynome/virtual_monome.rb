module Polynome
  class VirtualMonome
    attr_reader :cable_orientation, :model, :min_x, :max_x, :min_y, :max_y
    
    def initialize(opts={})
      opts.reverse_merge!(
                          :cable_orientation => :top,
                          :model             => :sixty_four
                          )

      @cable_orientation = opts[:cable_orientation]
      @model             = opts[:model]
      set_ranges
    end

    def set_ranges
      @min_x = 1
      @min_y = 1
      
      max_vals = case @model
                 when :sixty_four
                   [8,8]
                 when :one_twenty_eight
                   case @cable_orientation
                   when :top
                     [16,8]
                   when :bottom
                     [16,8]
                   when :left
                     [8,16]
                   when :right
                     [8,16]
                   end
                 when :two_fifty_six
                   [16,16]
                 else raise "unknown monome model: #{@model}"
                 end

      @max_x, @max_y = *max_vals
    end      
  end
end
