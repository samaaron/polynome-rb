module Polynome
  class Monome
    attr_reader  :model, :current_surface, :communicator

    def initialize(opts={})
      opts.reverse_merge! :cable_orientation => :top

      unless opts[:io_file] then
        raise ArgumentError,
        "Polynome::Monome#initialize requires an io_file to be specified"
      end
      unless opts[:model] then
        raise ArgumentError,
        "Polynome::Monome#initialize requires a model to be specified"
      end

      @model = Model.get_model(opts[:model], :landscape,  opts[:cable_orientation])
      @communicator = MonomeSerial::MonomeCommunicator.new(opts[:io_file], @model.protocol)
      @surfaces = [Surface.new("base", num_quadrants, self)]
      @current_surface = @surfaces[0]
    end


    def light_quadrant(quadrant_id, frame)
      if (quadrant_id < 1) || (quadrant_id > num_quadrants) then
        raise ArgumentError,
          "Unexpected quadrant id. Expected one of the set " +
          "#{(1..num_quadrants).to_a.join(', ')}, got #{quadrant_id}"
      end

      @model.default_rotate_frame_according_to_device_offset_and_cable_orientation(frame)
      mapped_quadrant_id = @model.default_map_quadrant_according_to_device_offset_and_cable_orientation(quadrant_id)
      @communicator.illuminate_frame(mapped_quadrant_id, frame.read)
    end

    def cable_orientation
      @model.cable_orientation
    end

    def num_quadrants
      @model.num_quadrants
    end

    def cable_orientation_offset
      @model.cable_orientation_offset(@cable_orientation)
    end

    def num_surfaces
      @surfaces.size
    end

    def add_surface(name)
      if find_surface_index_by_name(name) then
        raise Surface::DuplicateSurfaceError,
        "A surface with the name #{name} already exists!"
      end
      surface = Surface.new(name, num_quadrants, self)
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
