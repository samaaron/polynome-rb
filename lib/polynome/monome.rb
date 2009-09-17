module Polynome
  class Monome
    CABLE_ORIENTATIONS = [:top, :bottom, :left, :right]

    attr_reader :cable_orientation, :model

    def initialize(opts={})
      opts.reverse_merge! :cable_orientation => :top

      raise ArgumentError, "Polynome::Monome#initialize requires an io_file to be specified" unless opts[:io_file]
      raise ArgumentError, "Polynome::Monome#initialize requires a model to be specified"    unless opts[:model]
      raise ArgumentError, "Unknown cable orientation: #{opts[:cable_orientation]}, expected #{CABLE_ORIENTATIONS.to_sentence(:last_word_connector => ' or ')}" unless CABLE_ORIENTATIONS.include?(opts[:cable_orientation])

      @model = MonomeModel.get_model(opts[:model])
      @cable_orientation = opts[:cable_orientation]
      @communicator = MonomeSerial::MonomeCommunicator.new(opts[:io_file], @model.protocol)
      @surfaces = {}
    end

    def num_frames_supported
      @model.num_frames
    end

    def num_surfaces
      @surfaces.keys.size
    end
  end
end
