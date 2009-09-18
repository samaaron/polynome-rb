module Polynome
  class Surface
    ALLOWED_FRAME_COUNTS = [1,2,4]
    attr_reader :num_frames

    def initialize(num_frames)
      raise ArgumentError, "Unexpected number of frames. Expected one of the set {#{ALLOWED_FRAME_COUNTS.join(', ')}}. Got #{num_frames}" unless ALLOWED_FRAME_COUNTS.include?(num_frames)

      @frame_queue = Queue.new
      @num_frames = num_frames
    end

    def update_frame_buffer(*frames)
      raise ArgumentError, "Incorret number of frames sent. Was expecting #{num_frames}, got #{frames.size}" if frames.size != num_frames

      @frame_queue << frames
    end

    def fetch_frame_buffer
      @frame_queue.pop
    end
  end
end
