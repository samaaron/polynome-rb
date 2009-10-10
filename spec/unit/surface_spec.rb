require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Surface do
  it "should resolve to the correct constant from this context" do
    Surface.should == Polynome::Surface
  end

  describe "#initialize" do
    it "should be possible to initialize a surface specifying the number of frames that surface consists of" do
      lambda{Surface.new("test", 1)}.should_not raise_error
    end

    it "should raise an ArgumentError if the number of frames specified is less than 1" do
      lambda{Surface.new("test", 0)}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if the number of frames specified is 3" do
      lambda{Surface.new("test", 3)}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if the number of frames specified is greater than 4" do
      lambda{Surface.new("test", 5)}.should raise_error(ArgumentError)
    end
  end

  describe "#num_quadrants" do
    it "should report the number of frames the surface has" do
      Surface.new("test", 4).num_quadrants.should == 4
    end

    it "should report that a surface initialised with four frames has four frames" do
      Surface.new("test", 4).num_quadrants.should == 4
    end

    it "should report that a sufrace initialised with two frames has two frames" do
      Surface.new("test", 2).num_quadrants.should == 2
    end
  end

  describe "#update_frame_buffer" do
    it "should raise an ArgumentError if no frames are sent" do
      lambda{Surface.new("test", 1).update_display()}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if a frame with an index of 0 is sent" do
      frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
      lambda{Surface.new("test", 1).update_display(0, frame)}.should raise_error(ArgumentError)
    end
  end

  describe "given a surface with 1 frame" do
    before(:each) do
      @surface = Surface.new("test", 1)
    end

    it "should only have one quadrant" do
      @surface.num_quadrants.should == 1
    end

    describe "#update_display" do
      it "should raise an ArgumentError if a frame with an index of 2 is sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface.update_display(2, frame)}.should raise_error(ArgumentError)
      end
    end

    describe "#register_application" do
      describe "with a 64 application" do
        before(:each) do
          @app = AppConnector.new(:model => "64")
        end

        it "should be possible to register a one-framed application with this surface" do
          lambda{@surface.register_application(@app, :quadrants => [1], :rotation => 0)}.should_not raise_error
        end

        it "should raise an error if no quadrant option is passed" do
          lambda{@surface.register_application(@app, :rotation => 0)}.should raise_error(ArgumentError)
        end

        it "should default to a rotation of 0 if no rotation option is passed" do
          @surface.register_application(@app, :quadrants => [1]).rotation.should == 0
        end

        it "should raise a SurfaceSizeError if more than one quadrant is specified" do
          lambda{@surface.register_application(@app, :quadrants => [1,2])}.should raise_error(Surface::SurfaceSizeError)
        end

        it "should raise a QuadrantInUseError if the quadrant requested is already in use" do
          @surface.register_application(@app, :quadrants => [1])
          app2 = AppConnector.new(:model => "64")
          lambda{@surface.register_application(app2, :quadrants => [1])}.should raise_error(Surface::QuadrantInUseError)
        end
      end
    end
  end

  describe "given a surface with 2 frames" do
    before(:each) do
      @surface = Surface.new("test", 2)
    end

    it "should have two frames" do
      @surface.num_quadrants.should == 2
    end

    describe "#update_display" do
      it "should raise an ArgumentError if an index of 3 sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface.update_display(3, frame)}.should raise_error(ArgumentError)
      end
    end

    describe "#register_application" do
      describe "with a 64 application" do
        before(:each) do
          @app = AppConnector.new(:model => "64")
        end

        it "should raise an error if the number of quadrants specified doesn't match the application's interface" do
          lambda{@surface.register_application(@app, :quadrants => [1,2])}.should raise_error(Projection::QuadrantCountMismatchError)
        end

        it "should raise an error if, after placing a 64 app on the surface, a 128 was attempted to be placed" do
          @surface.register_application(@app, :quadrants => [1])
          app2 = AppConnector.new(:model => "128")
          lambda{@surface.register_application(app2, :quadrants => [1,2])}.should raise_error(Surface::QuadrantInUseError)
        end

        it "should be possible to place the application on the first quadrant via the singular keyword quadrant" do
          lambda{@surface.register_application(@app, :quadrant => [1])}.should_not raise_error
        end

        it "should be possible to place the application on the second quadrant via the singular keyword quadrant" do
          lambda{@surface.register_application(@app, :quadrant => [2])}.should_not raise_error
        end

        it "should be possible to place two similar 64 apps on both of the available quadrants" do
          app2 = AppConnector.new(:model => "64")
          lambda do
            @surface.register_application(@app, :quadrant => [1])
            @surface.register_application(app2, :quadrant => [2])
          end.should_not raise_error
        end
      end

      describe "with a 128 application" do
        before(:each) do
          @app = AppConnector.new(:model => "128")
        end

        it "should raise an error if the number of quadrants specified doesn't match the application's interface" do
          lambda{@surface.register_application(@app, :quadrants => [1])}.should raise_error(Projection::QuadrantCountMismatchError)
        end

        it "should not raise an error if the application is registered with the surface" do
          lambda{@surface.register_application(@app, :quadrants => [1,2])}.should_not raise_error
        end
      end

      describe "with a 256 application" do
        before(:each) do
          @app = AppConnector.new(:model => "256")
        end

        it "should raise an error if the number of quadrants specified doesn' tmatch the applications interface" do
          lambda{@surface.register_application(@app, :quadrants => [1,2])}.should raise_error(Projection::QuadrantCountMismatchError)
        end

        it "should raise an error if the application is attempted to be placed on this surface" do
          lambda{@surface.register_application(@app, :quadrants => [1,2,3,4])}.should raise_error(Surface::SurfaceSizeError)
        end
      end
    end
  end

  describe "given a surface with 4 frames" do
    before(:each) do
      @surface = Surface.new("test", 4)
    end

    it "should have four frames" do
      @surface.num_quadrants.should == 4
    end

    describe "#update_display" do
      it "should raise an ArgumentError if a frame with an index of 5 is sent" do
        frame = Frame.new("1111111111111111111111111111111111111111111111111111111111111111")
        lambda{@surface.update_display(5, frame)}.should raise_error(ArgumentError)
      end
    end

    describe "#register_application" do
      describe "with a 256 application" do
        before(:each) do
          @app = AppConnector.new(:model => "256")
        end

        it "should be possible to register it on a blank surface" do
          lambda{@surface.register_application(@app, :quadrants => [1,2,3,4])}.should_not raise_error
        end
      end
    end
  end
end
