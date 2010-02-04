module Polynome
  class Monome
    attr_reader  :model, :communicator, :carousel, :name

    # Create a new monome
    #
    # @param [Hash] opts the options to create a new monome with
    # @option opts [Symbol] :cable_placement (:top) The placement of the cable. One of [:top, :bottom, :left, :right].
    # @option opts [Symbol] :name (opts[:io_file]) A name for the monome.
    # @option opts [Symbol] :io_file The io file representing this monome.
    # @option opts [Symbol] :device The monome device type. One of ['64', '40h', '128', '256'].
    #
    def initialize(opts={})
      opts.reverse_merge! :cable_placement => :top
      opts.reverse_merge! :name => opts[:io_file]

      unless opts[:io_file] then
        raise ArgumentError,
        "Polynome::Monome#initialize requires an io_file to be specified",
        caller
      end

      unless opts[:device] then
        raise ArgumentError,
        "Polynome::Monome#initialize requires a device to be specified",
        caller
      end

      unless opts[:name] then
        raise ArgumentError,
        "Polynome::Monome#initialize requires a name to be specified",
        caller
      end

      @name = opts[:name]
      @model = Model.get_model(opts[:device].to_s, :cable_placement => opts[:cable_placement])
      @communicator = MonomeSerial::MonomeCommunicator.new(opts[:io_file], :protocol => @model.protocol)
      @carousel = Carousel.new(self)
    end

    def light_quadrant(quadrant_id, frame)

      if (quadrant_id < 1) || (quadrant_id > num_quadrants) then
        raise ArgumentError,
        "Unexpected quadrant id. Expected one of the set "/
        "#{(1..num_quadrants).to_a.join(', ')}, got #{quadrant_id}",
        caller
      end

      @model.rotate_frame!(frame)
      mapped_quadrant_id = @model.map_quadrant_id(quadrant_id)
      send_frame_to_communicator(mapped_quadrant_id, frame)
    end

    def cable_placement
      @model.cable_placement
    end

    def num_quadrants
      @model.num_quadrants
    end

    def cable_placement_offset
      @model.cable_placement_offset(@cable_placement)
    end

    def process_frame_update(frame_update)
      carousel.process_frame_update(frame_update)
    end

    def inspect
      "Monome, model: #{@model.name}, cable_placement: #{@model.cable_placement}, carousel: #{@carousel.inspect}".color(:blue)
    end

    def has_real_communicator?
      @communicator.is_real?
    end

    def listen
      @listen_thread = Thread.new do
        loop do
          action, x, y = *@communicator.read
          receive_button_event(action, x, y, true)
        end
      end
    end

    def add_app(app)
      #TODO remove this when possible!
      @app = app
    end

    def receive_button_event(action, x, y, log=false)

      puts "[MONOME]      receiving #{action} x:#{x}, y:#{y}" if log

      x += 1
      y += 1

      quadrant_id = button_quadrant(x,y)
      m_x, m_y = mapped_coords(x,y, quadrant_id)
      puts "calling carousel with action: #{action}, x: #{m_x}, y: #{m_y}"
      @carousel.receive_button_event(quadrant_id, action, m_x, m_y, log)
    end

    def button_quadrant(x,y)
      model.button_quadrant(x,y)
    end

    def mapped_coords(x,y, quadrant_id)
      model.map_coords_based_on_rotation(x,y, quadrant_id)
    end

    def quadrant_projection(quadrant_id)

    end

    def send_frame_to_communicator(quadrant_id, frame)
      @communicator.illuminate_frame(quadrant_id, frame.read)
    end
  end
end
