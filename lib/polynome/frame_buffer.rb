module Polynome
  class FrameBuffer
    def initialize
      @frame_queue = SizedQueue.new(Defaults::FRAME_BUFFER_SIZE)
    end

    def fetch_frame
      @frame_queue.pop
    end

    def push_frame(frame)
      @frame_queue.push(frame)
    end
  end
end
