module Polynome
  class Carousel
    attr_reader :current

    def initialize(monome)
      @surfaces = [Surface.new("base", monome)]
      @current = @surfaces[0]
      @monome = monome
    end

    def add(name)
      if find_surface_index_by_name(name) then
        raise Surface::DuplicateSurfaceError,
        "A surface with the name #{name} already exists!"
      end
      surface = Surface.new(name, @monome)
      @surfaces << surface
      return surface
    end

    def remove(name)
      validate_surface_name!(name)
      index = find_surface_index_by_name(name)
      @surfaces.delete_at(index)
    end

    def fetch(name)
      validate_surface_name!(name)
      @surfaces.find{|surface| surface.name == name.to_s}
    end

    def switch_to(name)
      validate_surface_name!(name)
      @current = find_surface_by_name(name)
    end

    def next
      index = find_surface_index_by_name(@current.name)
      index += 1
      index = 0 if index >= @surfaces.size
      @current = @surfaces[index]
    end

    def previous
      index = find_surface_index_by_name(@current.name)
      index -= 1
      index = @surfaces.size - 1 if index <= 0
      @current = @surfaces[index]
    end

    def size
      @surfaces.size
    end

    def process_frame_update(frame_update)
      @surfaces.each{|surface| surface.process_frame_update(frame_update)}
    end

    def inspect
      "Carousel, #{@surfaces.size} surfaces, #{@surfaces.map(&:name).inspect}".color(:green)
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
