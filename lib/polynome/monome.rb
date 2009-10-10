module Polynome
  class Monome
    attr_reader :cable_orientation, :model, :current_surface, :t1, :t2

    def initialize(opts={})
      opts.reverse_merge! :cable_orientation => :top

      raise ArgumentError, "Polynome::Monome#initialize requires an io_file to be specified" unless opts[:io_file]
      raise ArgumentError, "Polynome::Monome#initialize requires a model to be specified"    unless opts[:model]
      raise ArgumentError, "Unknown cable orientation: #{opts[:cable_orientation]}, expected #{Model.list_possible_cable_orientations}" unless Model.valid_cable_orientation?(opts[:cable_orientation])

      @model = Model.get_model(opts[:model])
      @cable_orientation = opts[:cable_orientation]
      @communicator = MonomeSerial::MonomeCommunicator.new(opts[:io_file], @model.protocol)
      @surfaces = [Surface.new("base", num_frame_buffers)]
      @current_surface = @surfaces[0]
      @frame_buffer = FrameBuffer.new
    end

    def update_frame_buffer(*frames)
      if frames.size != num_frames then
        raise ArgumentError,
        "Incorret number of frames sent. Was expecting " +
          "#{num_frames}, got #{frames.size}"
      end

      @frame_queue << frames
    end

    def num_frame_buffers
      @model.num_quadrants
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

    def add_surface(name)
      if find_surface_index_by_name(name) then
        raise Surface::DuplicateSurfaceError,
        "A surface with the name #{name} already exists!"
      end

      @surfaces << Surface.new(name, num_frame_buffers)
      self
    end

    def remove_surface(name)
      index = find_surface_index_by_name(name)
      unless index then
        raise Surface::UnknownSurfaceError,
        "A surface with the name #{name} does not exist"
      end

      @surfaces.delete_at(index)
      self
    end

    private

    def find_surface_index_by_name(name)
      @surfaces.find_index{|surface| surface.name == name.to_s}
    end
  end
end
