module Polynome
  class Monome
    CABLE_ORIENTATIONS = [:top, :bottom, :left, :right]

    attr_reader :cable_orientation, :model, :current_surface, :t1, :t2

    def initialize(opts={})
      opts.reverse_merge! :cable_orientation => :top

      raise ArgumentError, "Polynome::Monome#initialize requires an io_file to be specified" unless opts[:io_file]
      raise ArgumentError, "Polynome::Monome#initialize requires a model to be specified"    unless opts[:model]
      raise ArgumentError, "Unknown cable orientation: #{opts[:cable_orientation]}, expected #{CABLE_ORIENTATIONS.to_sentence(:last_word_connector => ' or ')}" unless CABLE_ORIENTATIONS.include?(opts[:cable_orientation])

      @model = Model.get_model(opts[:model])
      @cable_orientation = opts[:cable_orientation]
      @communicator = MonomeSerial::MonomeCommunicator.new(opts[:io_file], @model.protocol)
      @surfaces = [Surface.new(num_frame_buffers)]
      @current_surface = @surfaces[0]
    end

    def num_frame_buffers
      @model.num_frames
    end

    def display_buffer
      buffer_to_display = current_surface.fetch_frame_buffer
      buffer_to_display.each_with_index do |frame, index|
        @communicator.illuminate_frame(index, frame.read)
      end
    end

    def run_display
      @t2 = Thread.new do
        loop{display_buffer}
      end
    end

    def num_surfaces
      @surfaces.size
    end
  end
end
