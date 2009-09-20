module Polynome
  # Represents the physical LED display of a given monome
  class Display
    def initialize(communicator, num_frames)
      @frame_queue = SizedQueue.new(100)
      @communicator = communicator
      @frame_buffers = initialize_frame_buffers(num_frames)
    end

    private
    def initialize_frame_buffers(num_frames)
      case num_frames
      when 1 then {1 => FrameBuffer.new}
      when 2 then {1 => FrameBuffer.new, 2 => FrameBuffer.new}
      when 4 then {1 => FrameBuffer.new, 2 => FrameBuffer.new, 3 => FrameBuffer.new, 4 => FrameBuffer.new}
      else raise ArgumentError, "Unexpected number of frames. Expected 1, 2 or 4, got #{num_frames}"
      end
    end
  end
end

