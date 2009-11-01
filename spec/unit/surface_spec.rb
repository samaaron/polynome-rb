require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Surface do
  describe "given 3 applications, one 64, one 128 and one 256, 3 surfaces (1,2, 4 quadrants)" do

    before(:each) do
      @app64  = Application.new(:model => 64,  :name => "app64")
      @app128 = Application.new(:model => 128, :name => "app128")
      @app256 = Application.new(:model => 256, :name => "app256")
      @monome64  = Monome.new(:io_file => "blah", :model => "64",  :cable_orientation => :top)
      @monome128 = Monome.new(:io_file => "blah", :model => "128", :cable_orientation => :top)
      @monome256 = Monome.new(:io_file => "blah", :model => "256", :cable_orientation => :top)
      @surface1 = @monome64.add_surface("surface1")
      @surface2 = @monome128.add_surface("surface2")
      @surface4 = @monome256.add_surface("surface4")
    end

    it "should resolve to the correct constant from this context" do
      Surface.should == Polynome::Surface
    end

    describe "#initialize" do
      it "should be possible to initialize a surface specifying the number of frames that surface consists of" do
        lambda{Surface.new("test", 1, @monome64)}.should_not raise_error
      end

      it "should raise an ArgumentError if the number of frames specified is less than 1" do
        lambda{Surface.new("test", 0, @monome64)}.should raise_error(ArgumentError)
      end

      it "should raise an ArgumentError if the number of frames specified is 3" do
        lambda{Surface.new("test", 3, @monome256)}.should raise_error(ArgumentError)
      end

      it "should raise an ArgumentError if the number of frames specified is greater than 4" do
        lambda{Surface.new("test", 5, @monome256)}.should raise_error(ArgumentError)
      end
    end

    describe "#num_quadrants" do
      it "should report that a surface initialised with four frames has four frames" do
        @surface4.num_quadrants.should == 4
      end

      it "should report that a surface initialised with two frames has two frames" do
        @surface2.num_quadrants.should == 2
      end

      it "should report that a surface initialised with one frame has one frame" do
        @surface1.num_quadrants.should == 1
      end
    end

    describe "#update_frame_buffer" do
      it "should raise an ArgumentError if no frames are sent" do
        lambda{@surface1.light_quadrant()}.should raise_error(ArgumentError)
      end

      it "should raise an ArgumentError if a frame with an index of 0 is sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface1.light_quadrant(0, frame)}.should raise_error(ArgumentError)
      end
    end

    describe "#registered_applications" do
      it "should start with no applications registered" do
        @surface1.registered_applications.should == []
      end

      it "should return the application you have already registered" do
        @surface1.register_application(@app64, :quadrant => 1)
        @surface1.registered_applications.should == [@app64]
      end

      it "should return multiple applications if you have registered multiple applications" do
        @surface4.register_application(@app64, :quadrant => 1)
        @surface4.register_application(@app128, :quadrants => [3,4])
        @surface4.registered_applications.should =~ [@app64, @app128]
      end
    end

    describe "#remove_application" do
      it "should raise an error if the application you tried to remove isn't registered" do
        lambda{@surface1.remove_application("foobarbaz")}.should raise_error(Surface::UnknownAppError)
      end

      it "should remove an application you have previously registered" do
        @surface1.registered_applications.should == []
        @surface1.register_application(@app64, :quadrant => 1)
        @surface1.registered_applications.should == [@app64]
        @surface1.remove_application(@app64.name)
        @surface1.registered_applications.should == []
      end

      it "should remove the correct application if you have registered multiple applications" do
        @surface4.register_application(@app64, :quadrant => 1)
        @surface4.register_application(@app128, :quadrants => [3,4])
        @surface4.registered_applications.should =~ [@app64, @app128]
        @surface4.remove_application(@app64.name)
        @surface4.registered_applications.should =~ [@app128]
      end

      it "should be possible to register an application into a space where an application has just been removed" do
        @surface4.register_application(@app64, :quadrant => 1)
        @surface4.register_application(@app128, :quadrants => [3,4])
        @surface4.registered_applications.should =~ [@app64, @app128]
        @surface4.remove_application(@app64.name)
        new_app = Application.new(:model => 128, :name => "new_app128")
        @surface4.register_application(new_app, :quadrants => [1,2])
        @surface4.registered_applications.should =~ [@app128, new_app]
      end
    end

    describe "#current_surface?" do
      it "should be the current surface if it matches the monome's current surface" do
        @surface1.should_not be_current_surface
        @monome64.switch_to_surface("surface1")
        @surface1.should be_current_surface
      end
    end

    describe "#light_quadrant" do
      it "should raise an ArgumentError if a frame with an index of 2 is sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface1.light_quadrant(2, frame)}.should raise_error(ArgumentError)
      end

      it "should raise an ArgumentError if an index of 3 sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface2.light_quadrant(3, frame)}.should raise_error(ArgumentError)
      end

      it "should raise an ArgumentError if a frame with an index of 5 is sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface4.light_quadrant(5, frame)}.should raise_error(ArgumentError)
      end
    end

    describe "#register_application" do
      describe "with respect to a one-quadrant surface" do
        it "should be possible to omit the quadrant option" do
          lambda{@surface1.register_application(@app64, :rotation => 0)}.should_not raise_error(ArgumentError)
        end

        it "should default to a rotation of 0 if no rotation option is passed" do
          @surface1.register_application(@app64, :quadrants => [1]).rotation.should == 0
        end


        it "should be possible to register a one-framed application with a one quadrant surface" do
          lambda{@surface1.register_application(@app64, :quadrants => [1], :rotation => 0)}.should_not raise_error
        end


        it "should default to the first quadrant regardless of what quadrants option is passed" do
          lambda{@surface1.register_application(@app64, :quadrants => [1,2])}.should_not raise_error
        end
      end

      describe "with respect to two-quadrant surface" do
        it "should raise an error if the number of quadrants specified doesn' tmatch the applications interface" do
          lambda{@surface2.register_application(@app256, :quadrants => [1,2])}.should raise_error(Projection::QuadrantCountMismatchError)
        end

        it "should raise an error if the application is attempted to be placed on this surface" do
          lambda{@surface2.register_application(@app256, :quadrants => [1,2,3,4])}.should raise_error(Surface::SurfaceSizeError)
        end

        it "should raise an error if the number of quadrants specified doesn't match the application's interface" do
          lambda{@surface2.register_application(@app128, :quadrant => 1)}.should raise_error(Projection::QuadrantCountMismatchError)
        end

        it "should not raise an error if the application is registered with the surface" do
          lambda{@surface2.register_application(@app128, :quadrants => [1,2])}.should_not raise_error
        end

        it "should raise an error if the number of quadrants specified doesn't match the application's interface" do
          lambda{@surface2.register_application(@app64, :quadrants => [1,2])}.should raise_error(Projection::QuadrantCountMismatchError)
        end

        it "should be possible to place the application on the first quadrant via the singular keyword quadrant" do
          lambda{@surface2.register_application(@app64, :quadrant => 1)}.should_not raise_error
        end

        it "should be possible to place the application on the second quadrant via the singular keyword quadrant" do
          lambda{@surface2.register_application(@app64, :quadrant => 2)}.should_not raise_error
        end

        it "should be possible to place two similar 64 apps on both of the available quadrants" do
          app2 = Application.new(:model => "64", :name => "app2_64")
          lambda do
            @surface2.register_application(@app64, :quadrant => 1)
            @surface2.register_application(app2, :quadrant => 2)
          end.should_not raise_error
        end
      end

      describe "with respect to a four-quardant surface" do

        it "should raise an error if the number of quadrants specified doesn't match the application's interface" do
          lambda{@surface4.register_application(@app64, :quadrants => [1,2])}.should raise_error(Projection::QuadrantCountMismatchError)
        end


        it "should be possible to place the application on the first quadrant via the singular keyword quadrant" do
          lambda{@surface4.register_application(@app64, :quadrant => 1)}.should_not raise_error
        end

        it "should be possible to place the application on the second quadrant via the singular keyword quadrant" do
          lambda{@surface4.register_application(@app64, :quadrant => 2)}.should_not raise_error
        end

        it "should be possible to place the application on the third quadrant via the singular keyword quadrant" do
          lambda{@surface4.register_application(@app64, :quadrant => 3)}.should_not raise_error
        end

        it "should be possible to place the application on the fourth quadrant via the singular keyword quadrant" do
          lambda{@surface4.register_application(@app64, :quadrant => 4)}.should_not raise_error
        end


        it "should be possible to register it on the left half in portrait mode" do
          lambda{@surface4.register_application(@app128, :quadrants => [1,3])}.should_not raise_error
        end

        it "should be possible to register it on the right half in portrait mode" do
          lambda{@surface4.register_application(@app128, :quadrants => [2,4])}.should_not raise_error
        end


        it "should be possible to register it on a blank surface" do
          lambda{@surface4.register_application(@app256, :quadrants => [1,2,3,4])}.should_not raise_error
        end

        it "should be possible to place four similar 64 apps on all of the available quadrants" do
          app2 = Application.new(:model => 64, :name => "test2")
          app3 = Application.new(:model => 64, :name => "test3")
          app4 = Application.new(:model => 64, :name => "test4")
          lambda do
            @surface4.register_application(@app64, :quadrant => 1)
            @surface4.register_application(app2, :quadrant => 2)
            @surface4.register_application(app3, :quadrant => 3)
            @surface4.register_application(app4, :quadrant => 4)
          end.should_not raise_error
        end
      end

      describe "when there is insufficient space" do
        it "should raise a QuadrantInUseError if the quadrant requested is already in use" do
          @surface1.register_application(@app64, :quadrants => [1])
          app2 = Application.new(:model => "64", :name => "app2_64")
          lambda{@surface1.register_application(app2, :quadrants => [1])}.should raise_error(Surface::QuadrantInUseError)
        end

        it "should raise an error if, after placing a 64 app on the surface, a 128 was attempted to be placed" do
          @surface2.register_application(@app64, :quadrant => 1)
          lambda{@surface2.register_application(@app128, :quadrants => [1,2])}.should raise_error(Surface::QuadrantInUseError)
        end

        it "should raise an error if, after placing a 64 app on the surface, a 256 was attempted to be placed" do
          @surface4.register_application(@app64, :quadrant => 1)
          app2 = Application.new(:model => 256, :name => "app2_256")
          lambda{@surface4.register_application(app2, :quadrants => [1,2,3,4])}.should raise_error(Surface::QuadrantInUseError)
        end

        describe  "given the 128 app is registered on the top half in landscape mode (quadrants 1,2)" do
          before(:each) do
            lambda{@surface4.register_application(@app128, :quadrants => [1,2])}.should_not raise_error
          end

          invalid_quadrants = [1,2]
          invalid_quadrants.each do |quadrant_id|
            it "should raise an error if a 64 was placed on quadrant #{quadrant_id}" do
              lambda{@surface4.register_application(@app64, :quadrant => quadrant_id)}.should raise_error(Surface::QuadrantInUseError)
            end
          end

          valid_quadrants = [3,4]
          valid_quadrants.each do |quadrant_id|
            it "should not raise an error if a 64 was placed on quadrant #{quadrant_id}" do
              lambda{@surface4.register_application(@app64, :quadrant => quadrant_id)}.should_not raise_error
            end
          end

          invalid_quadrants = [[1,2], [1,3], [2,4]]
          invalid_quadrants.each do |quadrant_ids|
            it "should raise an error if a 128 was placed on quadrants #{quadrant_ids.inspect}" do
              lambda{@surface4.register_application(@app128, :quadrants => quadrant_ids)}.should raise_error(Surface::QuadrantInUseError)
            end
          end

          it "should not raise an error if a 128 was placed on quadrants 3,4" do
            lambda{@surface4.register_application(@app128, :quadrants => [3,4])}.should_not raise_error
          end

          it "should raise an error if a 256 was placed on quadrants 1,2,3,4" do
            lambda{@surface4.register_application(@app256, :quadrants => [1,2,3,4])}.should raise_error(Surface::QuadrantInUseError)
          end

          it "should be possible to register it on the bottom half in landscape mode" do
            lambda{@surface4.register_application(@app128, :quadrants => [3,4])}.should_not raise_error
          end

        end

        describe "given the 256 is registered on the entire surface" do
          before(:each) do
            @surface4.register_application(@app256, :quadrants => [1,2,3,4])
          end

          invalid_quadrants = [1,2,3,4]
          invalid_quadrants.each do |quadrant_id|
            it "should raise an error if a 64 was placed on quadrant #{quadrant_id}" do
              lambda{@surface4.register_application(@app64, :quadrant => quadrant_id)}.should raise_error(Surface::QuadrantInUseError)
            end
          end

          invalid_quadrants = [[1,2], [3,4], [1,3], [2,4]]
          invalid_quadrants.each do |quadrant_id|
            it "should raise an error if a 128 was placed on quadrant #{quadrant_id}" do
              lambda{@surface4.register_application(@app128, :quadrants => quadrant_id)}.should raise_error(Surface::QuadrantInUseError)
            end
          end

          it "should raise an error if the 256 is placed on the surface" do
            lambda{@surface4.register_application(@app256, :quadrants => [1,2,3,4])}.should raise_error(Surface::QuadrantInUseError)
          end
        end
      end
    end
  end
end
