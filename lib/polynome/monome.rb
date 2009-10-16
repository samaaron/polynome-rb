module Polynome
  class Monome
    attr_reader :cable_orientation, :model, :current_surface

    def initialize(opts={})
      opts.reverse_merge! :cable_orientation => :top

      raise ArgumentError, "Polynome::Monome#initialize requires an io_file to be specified" unless opts[:io_file]
      raise ArgumentError, "Polynome::Monome#initialize requires a model to be specified"    unless opts[:model]
      raise ArgumentError, "Unknown cable orientation: #{opts[:cable_orientation]}, expected #{Model.list_possible_cable_orientations}" unless Model.valid_cable_orientation?(opts[:cable_orientation])

      @model = Model.get_model(opts[:model])
      @cable_orientation = opts[:cable_orientation]
      @communicator = MonomeSerial::MonomeCommunicator.new(opts[:io_file], @model.protocol)
      @surfaces = [Surface.new("base", num_frame_buffers, self)]
      @current_surface = @surfaces[0]
      @frame_buffer = FrameBuffer.new
    end

    def update_frame_buffer(*frames)
      if frames.size != num_frame_buffers then
        raise ArgumentError,
        "Incorrect number of frames sent. Was expecting " +
          "#{num_frame_buffers}, got #{frames.size}"
      end

      #TODO need to map frames based on cable orientation
      frames.each_with_index do |frame, index|
        @communicator.illuminate_frame(index + 1, frame.read)
      end
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
      surface = Surface.new(name, num_frame_buffers, self)
      @surfaces << surface
      return surface
    end

    def remove_surface(name)
      validate_surface_name!(name)
      index = find_surface_index_by_name(name)
      @surfaces.delete_at(index)
    end

    def fetch_surface(name)
      validate_surface_name!(name)
      @surfaces.find{|surface| surface.name == name.to_s}
    end

    def switch_to_surface(name)
      validate_surface_name!(name)
      @current_surface = find_surface_by_name(name)
    end

    def next_surface
      index = find_surface_index_by_name(@current_surface.name)
      index += 1
      index = 0 if index >= @surfaces.size
      @current_surface = @surfaces[index]
    end

    def previous_surface
      index = find_surface_index_by_name(@current_surface.name)
      index -= 1
      index = @surfaces.size - 1 if index <= 0
      @current_surface = @surfaces[index]
    end

    private

    def validate_surface_name!(name)
      unless find_surface_index_by_name(name) then
        raise Surface::UnknownSurfaceError,
        "A surface with the name #{name} does not exist"
      end
    end

    def find_surface_by_name(name)
      @surfaces.find{|surface| surface.name == name.to_s}
    end

    def find_surface_index_by_name(name)
      @surfaces.find_index{|surface| surface.name == name.to_s}
    end
  end
end
