module Polynome
  class Surface
    ALLOWED_FRAME_COUNTS = [1,2,4]
    attr_reader :num_frames

    def initialize(num_frames)
      raise ArgumentError, "Unexpected number of frames. Expected one of the set {#{ALLOWED_FRAME_COUNTS.join(', ')}}. Got #{num_frames}" unless ALLOWED_FRAME_COUNTS.include?(num_frames)

      @num_frames = num_frames
    end

    def update_display(index, frame)
      raise ArgumentError, "Unexpected frame index. Expected one of the set #{(1..@num_frames).to_a.join(', ')}, got #{num_frames}" if index < 1 || index > @num_frames

      #TODO: implement me!
      #if this is the current surface, update monome's display
      #if it isn't, then just store the frame locally
    end

    def fetch_frame_buffer
      @frame_queue.pop
    end
  end
end
