require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome
describe "Monome to Application updates" do
  describe "Given a 64 monome with cable placement top and a 64 app at 90 degree rotation" do
    before(:each) do
      @table  = Table.new(:ignore_connection_validity => true)
      @table.add_monome(:io_file => 'foo/bar', :device => "64")
      @table.add_app(:device => 64, :name => "app64")
      @monome = @table.send(:monome, "main")
      @app64  = @table.send(:app, "app64")
      @table.connect(:app => "app64", :monome => "main", :surface => "base", :rotation => 90)
      @projection = @monome.carousel.send(:current_surface).send(:find_projection_by_quadrant, 1)
    end

    describe "mapping button presses" do
      maps = {
        [7,7] => {:device_mapped => [1,1], :projection_mapped => []},
        [0,0] => {:device_mapped => [8,8], :projection_mapped => []},
        [7,1] => {:device_mapped => [1,7], :projection_mapped => []},
        [1,7] => {:device_mapped => [7,1], :projection_mapped => []},
        [1,6] => {:device_mapped => [7,2], :projection_mapped => []}
      }

      maps.each do |raw, mappings|
        it "should map #{raw.inspect} to #{mappings[:device_mapped].inspect} and pass the mapped coords to the carousel" do
          @monome.carousel.should_receive(:receive_button_event).with(1, :keydown, mappings[:device_mapped].first, mappings[:device_mapped].last, false)
          @monome.receive_button_event(:keydown, raw.first, raw.last, false)
        end

        it "should then pass the mapped coords to the carousel's current surface" do
          @monome.carousel.send(:current_surface).should_receive(:receive_button_event).with(1, :keydown, mappings[:device_mapped].first, mappings[:device_mapped].last, false)
          @monome.receive_button_event(:keydown, raw.first, raw.last, false)
        end

        it "should also pass the mapped coords to the projection that contains the app" do
          @projection.should_receive(:receive_button_event).with(1, :keydown, mappings[:device_mapped].first, mappings[:device_mapped].last, false)
          @monome.receive_button_event(:keydown, raw.first, raw.last, false)
        end

        it "should finally map the coords again based on the projection rotation and pass them onto the app" do
          @app64.should_receive(:receive_button_event)
          @monome.receive_button_event(:keydown, raw.first, raw.last, false)
        end
      end
    end
  end

  describe "Given a 64 monome with cable placement left and a 64 app" do
    before(:each) do
      @table  = Table.new(:ignore_connection_validity => true)
      @table.add_monome(:io_file => 'foo/bar', :device => "64", :cable_placement => :left)
      @table.add_app(:device => 64, :name => "app64")
      @monome = @table.send(:monome, "main")
      @app64  = @table.send(:app, "app64")
    end

    describe "mapping button presses" do
      maps = {
        [7,7] => [1,8],
        [0,0] => [8,1],
        [7,1] => [7,8],
        [1,7] => [1,2],
        [1,6] => [2,2]
      }

      maps.each do |raw, mapped|
        it "should map #{raw.inspect} to #{mapped.inspect}" do
          @monome.carousel.should_receive(:receive_button_event).with(1, :keydown, mapped.first, mapped.last, false)
          @monome.receive_button_event(:keydown, raw.first, raw.last, false)
        end
      end
    end
  end
end

