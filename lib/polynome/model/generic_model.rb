module Polynome
  module Model

    # Abstract representation of a particular monome device
    class GenericModel
      VALID_CABLE_PLACEMENTS = [:top, :bottom, :left, :right]
      VALID_ROTATIONS        = [0, 90, 180, 270]

      attr_reader   :width, :height, :protocol, :num_quadrants, :name, :cable_placement, :rotation


      def initialize
        raise "Please call me from a subclass"
      end

      # Take a quadrant id and map it to a new position based on the model's rotation and cable placement
      # The behaviour of this method is generally specific to the model type as defined in +map_quadrant+.
      #
      # @param [Integer] quadrant_id The ID of the quadrant to map: one of (0|1|2|3) depending on device type.
      #
      # @return [Integer] The mapped quadrant id. One of (0|1|2|3) depending on device type.
      def map_quadrant_id(quadrant_id)
        #overidden in subclasses where necessary
        quadrant_id
      end

      # Rotate a frame according to the model's rotation and cable placemnt
      #
      # @param [Frame] frame The frame to rotate. Modifies this frame to rotate it appropriately
      def rotate_frame!(frame)
        rotation_offset.times{frame.rotate!(90)}
      end

      def map_coords_based_on_rotation(x,y)
        raise "I'd like to be implemented please"
      end

      def orientation
        :landscape
      end

      def rotation=(rotation)
        unless VALID_ROTATIONS.include?(rotation) then
          raise ArgumentError,
          "Incorrect rotation: #{rotation}. Expected one of 0, 90, 180 or 270",
          caller
        end
        @rotation = rotation
      end


      private

      def rotation_offset
        (cable_placement_rotation + @rotation + device_rotation_offset) % 4
      end

      def default_quadrants
        (1..@num_quadrants).to_a
      end

      def button_quadrant(x,y)
        raise "Please implement me"
      end

      def device_rotation_offset
        @device_rotation_offset || 0
      end

      def cable_placement=(cable_placement)
        unless VALID_CABLE_PLACEMENTS.include?(cable_placement) then
          raise ArgumentError,
          "Unknown cable placement: #{cable_placement}, "\
          "expected #{VALID_CABLE_PLACEMENTS.to_sentence(:last_word_connector => ' or ')}",
          caller
        end
        @cable_placement = cable_placement
      end


      def cable_placement_rotation
        case @cable_placement
        when :top    then 0
        when :right  then 3
        when :bottom then 2
        when :left   then 1
        else  raise ArgumentError, "Unknown cable placement. Expected #{VALID_CABLE_PLACEMENTS.to_sentence(:last_word_connector => ' or ')}, got #{cable_placement}", caller
        end
      end

      # Sets +@rotation+ and +@cable_placement+ with the correct values for this device given the current orientation, cable placement and device defaults.
      #
      # @param [String] orientation One of the set [:landscape, :portrait] where portrait is only currently supported by the 128.
      # @param [Symbol] cable_placement placement of the cable. One of +[:top, :right, :left, :bottom]+.
      #

      def set_rotation_and_cable_placement!(rotation, cable_placement)
        #make sure validations are triggered by using accessors
        self.rotation        = rotation
        self.cable_placement = cable_placement
      end
    end
  end
end
