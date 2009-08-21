module Polynome
  class VirtualMonome
    attr_reader :cable_orientation, :model, :min_x, :max_x, :min_y, :max_y, :input_port, :output_port

    def initialize(opts={})
      opts.reverse_merge!(
                          :cable_orientation => :top,
                          :model             => :sixty_four,
                          :input_port        => 9988,
                          :output_port       => 8899
                          )

      @cable_orientation = opts[:cable_orientation]
      @model             = opts[:model]
      @input_port        = opts[:input_port]
      @output_port       = opts[:output_port]

      @listener = OSCListener.new(@input_port)
      @sender   = OSCSender.new(@output_port)
      @sender.debug_mode("vm's sender")
      @listener.add_method :any, :any do |message|
        @sender.send(message.address, *message.args)
      end

      set_ranges
    end

    def power_up
      @listener.start
    end

    def power_down
      @listener.stop
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

    def debug_mode
      @listener.debug_mode("vm listener")
      @sender.debug_mode("vm sender")
    end
  end
end
