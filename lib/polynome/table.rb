module Polynome
  class Table
    attr_reader :rack
    def initialize
      @frame_buffer = SizedQueue.new(Defaults::FRAME_BUFFER_SIZE)
      @rack = Rack.new(@frame_buffer)
    end
  end
end
