 module Polynome
  class Model
    class InvalidOrientation < Exception ; end
    class InvalidButtonCoord < Exception ; end

    VALID_CABLE_ORIENTATIONS   = [:top, :bottom, :left, :right]
    DEFAULT_VALID_ORIENTATIONS = [:landscape]

    attr_reader :width, :height, :protocol, :num_quadrants, :name, :orientation, :cable_orientation

    def self.get_model(model, orientation = :landscape, cable_orientation = :top)
      case model
      when "40h" then return FourtyH.new(orientation, cable_orientation)
      when "64"  then return SixtyFour.new(orientation, cable_orientation)
      when "128" then return OneTwentyEight.new(orientation, cable_orientation)
      when "256" then return TwoFiftySix.new(orientation, cable_orientation)
      else raise ArgumentError, "Unknown monome model type: #{model}", caller
      end
    end

    def self.valid_cable_orientation?(orientation)
      VALID_CABLE_ORIENTATIONS.include?(orientation)
    end

    def self.list_possible_cable_orientations
      VALID_CABLE_ORIENTATIONS.to_sentence(:last_word_connector => ' or ')
    end


    def initialize(orientation, cable_orientation)
      unless self.class.valid_cable_orientation?(cable_orientation) then
        raise ArgumentError,
        "Unknown cable orientation: #{cable_orientation}, "\
        "expected #{self.class.list_possible_cable_orientations}",
        caller
      end

      @cable_orientation = cable_orientation
      @orientation       = orientation
    end

    def offset
      @device_orientation_offset + cable_orientation_offset
    end

    def default_map_quadrant_according_to_device_offset_and_cable_orientation(quadrant_id, debug=false)
       map_quadrant(quadrant_id, default_quadrants, offset)
    end

    def default_rotate_frame_according_to_device_offset_and_cable_orientation(frame)
      offset.times{frame.rotate!(90)}
      frame
    end

    def rotate_frame(frame, quadrants, rotation)
      frame.rotate!(rotation)
    end

    def map_quadrant(quadrant_id, quadrants, positive_rotational_offset)
      #ignore quadrants and offset
      quadrant_id
    end

    def map_coords_based_on_rotation(x,y)
      #return *[x,y]
      raise "I'd like to be implemented please"
    end

    def default_quadrants
      (1..@num_quadrants).to_a
    end

    def cable_orientation_offset
      case @cable_orientation
      when :top    then 0
      when :right  then 3
      when :bottom then 2
      when :left   then 1
      else  raise ArgumentError, "Uknown cable orientation. Expected #{CABLE_ORIENTATIONS.inspect}, got #{orientation}", caller
      end
    end

    def validate_orientation!(orientations = DEFAULT_VALID_ORIENTATIONS)
      unless orientations.include?(@orientation) then
        raise InvalidOrientation,
        "Invalid orientation: #{@orientation}. Was expecting one of "\
        "#{orientations.inspect}",
        caller
      end
    end

    def button_quadrant(x,y)
      raise "Please implement me"
    end
  end

  class FourtyH < Model
    def initialize(orientation, cable_orientation)
      super
      validate_orientation!
      @name                      = "40h"
      @width                     = 8
      @height                    = 8
      @protocol                  = "40h"
      @num_quadrants             = 1
      @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      @device_orientation_offset = 0
    end

    def button_quadrant(x,y)
      if (y <= 8 && x <= 8 && x >= 1 && y >= 1)
        1
      else
        raise InvalidButtonCoord, "Sorry, the coordinates you specified: "\
        "(#{x}, #{y}) are invalid for the 64. Expected x coord in the "\
        "range (1..8) and y coord in the range (1..8).",
        caller
      end
    end
  end

  class SixtyFour < Model
    def initialize(orientation, cable_orientation)
      super
      validate_orientation!
      @name                      = "64"
      @width                     = 8
      @height                    = 8
      @protocol                  = "series"
      @num_quadrants             = 1
      @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      @device_orientation_offset = 0
    end

    def button_quadrant(x,y)
      if (y <= 8 && x <= 8 && x >= 1 && y >= 1)
        1
      else
        raise InvalidButtonCoord, "Sorry, the coordinates you specified: "\
        "(#{x}, #{y}) are invalid for the 64. Expected x coord in the "\
        "range (1..8) and y coord in the range (1..8).",
        caller
      end
    end
  end

  class OneTwentyEight < Model
    def initialize(orientation, cable_orientation)
      super
      validate_orientation!(DEFAULT_VALID_ORIENTATIONS + [:portrait])
      @name                      = "128"
      @protocol                  = "series"
      @num_quadrants             = 2
      @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      @device_orientation_offset = 0
      @width  = @orientation == :landscape ? 16 : 8
      @height = @orientation == :landscape ? 8  : 16
    end

    def rotate_frame(frame, quadrants, rotation)
      super
      frame.rotate!(90) if [[1,3], [2,4]].include?(quadrants.to_a)
    end

    def map_quadrant(quadrant_id, quadrants, positive_rotational_offset)
      if [1,2].include?(positive_rotational_offset % 4)
        swap_quadrant_ids(quadrant_id, quadrants)
      else
        quadrant_id
      end
    end

    def button_quadrant(x,y)
      if @orientation == :landscape
        if (y <= 8 && x <= 8 && x >= 1 && y >= 1)
          1 #left
        elsif (y <= 8 && x <= 16 && x >= 9 && y >= 1)
          2 #right
        else
          raise InvalidButtonCoord, "Sorry, the coordinates you specified: "\
          "(#{x}, #{y}) are invalid for the 128 in orientation landscape. "\
          "Expected x coord in the range (1..16) and y coord in the range (1..8).",
          caller
        end
      else #in portrait orientation
        if (y <= 8 && x <= 8 && x >= 1 && y >= 1)
          2 #bottom
        elsif (y <= 16 && x <= 8 && x >= 1 && y >= 9)
          1 #top
        else
          raise InvalidButtonCoord, "Sorry, the coordinates you specified: "\
          "(#{x}, #{y}) are invalid for the 128 in orientation portrait. "\
          "Expected x coord in the range (1..8) and y coord in the range (1..16).",
          caller
        end
      end
    end

    private

    def swap_quadrant_ids(quadrant_id, quadrants)
      unless quadrants.include? quadrant_id then
        raise ArgumentError,
        "Unexpected quadrant id. Expected one of "\
        "#{quadrants.inspect}, got #{quadrant_id}",
        caller
      end

      unless quadrants.size == 2 then
        raise ArgumentError,
        "Expected quadrants for a 128 model to have only two elements. "\
        "Found #{quadrants.size}",
        caller
      end

      index = quadrants.index(quadrant_id)
      quadrants[index - 1]
    end
  end

  class TwoFiftySix < Model
    def initialize(orientation, cable_orientation)
      super
      validate_orientation!
      @name                      = "256"
      @width                     = 16
      @height                    = 16
      @protocol                  = "series"
      @num_quadrants             = 4
      @valid_quadrants           = Quadrants.get_valid_quadrants(@num_quadrants)
      @device_orientation_offset = 3
    end

    def map_quadrant(quadrant_id, quadrants,  positive_rotational_offset, clockwise_rotation = false)
      #ignore quadrants

      #currently I have to handle button presses in clockwise rotation
      #and frame displays in anticlockwise rotation
      #this really suggests this code is due for a major
      #refactoring ;-)
      offset = -positive_rotational_offset if clockwise_rotation

      clockwise_quadrant_order = [1,2,4,3]
      index = clockwise_quadrant_order.index(quadrant_id)
      new_index = (index + positive_rotational_offset) % 4
      result = clockwise_quadrant_order[new_index]
      result
    end

    def map_coords_based_on_rotation(x,y)
      case @cable_orientation
      when :top then x,y = y,x ; y = 16 - y ; x = 16 - x ; return x,y
      when :bottom then  x += 1 ; y += 1 ; return y,x
      when :left then y = 16 - y ; x += 1 ; return x,y
      when :right then x = 16 - x ; y += 1 ; return x,y
      else raise "Unknown cable orientation: #{@cable_orientation}"
      end
    end

    def button_quadrant(x,y)
      #return quadrant number as if cable is at top
      if (y <= 8 && x <= 8 && x >= 1 && y >= 1)
        3 # bottom left
      elsif (y <= 8 && x <= 16 && x >= 9 && y >= 1)
        4 # bottom right
      elsif (y <= 16 && x <= 16 && x >= 9 && y >= 9)
        2 # top right
      elsif (y <= 16 && x <= 8 && x >= 1 && y >= 9)
        1 # top left
      else
        raise InvalidButtonCoord, "Sorry, the coordinates you specified: "\
        "(#{x}, #{y}) are invalid for this device. Expected x coord in the "\
        "range (0..15) and y coord in the range (0..15).",
        caller
      end
    end
  end
end
