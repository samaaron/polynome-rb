module Polynome
  class Monome
    attr_reader  :model, :communicator, :carousel, :name

    def initialize(opts={})
      opts.reverse_merge! :cable_orientation => :top
      opts.reverse_merge! :name => opts[:io_file]

      unless opts[:io_file] then
        raise ArgumentError,
        "Polynome::Monome#initialize requires an io_file to be specified"
      end

      unless opts[:model] then
        raise ArgumentError,
        "Polynome::Monome#initialize requires a model to be specified"
      end

      unless opts[:name] then
        raise ArgumentError,
        "Polynome::Monome#initialize requires a name to be specified"
      end

      @name = opts[:name]
      @model = Model.get_model(opts[:model].to_s, :landscape,  opts[:cable_orientation])
      @communicator = MonomeSerial::MonomeCommunicator.new(opts[:io_file], @model.protocol)
      @carousel = Carousel.new(self)
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

    def process_frame_update(frame_update)
      carousel.process_frame_update(frame_update)
    end

    def inspect
      "Monome, model: #{@model.name}, cable_orientation: #{@model.cable_orientation}, carousel: #{@carousel.inspect}".color(:blue)
    end

    def has_real_communicator?
      @communicator.is_real?
    end

    def listen
      @listen_thread = Thread.new do
        loop do
          receive_button_event(*@communicator.read)
        end
      end
    end

    def add_app(app)
      #TODO remove this when possible!
      @app = app
    end

    def receive_button_event(action, x, y)
      quadrant = button_quadrant(x,y)
      if @app
        #temporarily here because it's nice to demo it working to
        #myself for kicks!
        @app.update_display(FrameFixtures.frame64)   if action == :keydown
        @app.update_display(FrameFixtures.blank) if action == :keyup
        puts "#{name}: #{action} - [x: #{x}, y:#{y}], raw: #{model.send(:raw_button_quadrant, x,y)}, mapped: #{button_quadrant(x,y)}"
      else
        @carousel.receive_button_event(quadrant, action, x, y)
      end
    end

    def button_quadrant(x,y)
      model.button_quadrant(x,y)
    end

    def quadrant_projection(quadrant_id)

    end
  end
end
