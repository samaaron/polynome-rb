require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome
describe "Application to Monome updates" do
  describe "Given a 64 monome with a 64 app" do
    before(:each) do
      @table   = Table.new(:ignore_connection_validity => true)
      @table.add_monome(:io_file => 'foo/bar', :device => "64")
      @table.add_app(:device => 64, :name => "app64")
      @monome = @table.send(:monome, "main")
      @app64  = @table.send(:app, "app64")
    end

    it "should rotate the frame 90 with a projection rotation of 90" do
      @table.connect(:app => "app64", :monome => "main", :surface => "base", :rotation => 90)
      @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64_90)
      @app64.update_display(FrameFixtures.frame64)
      @table.send(:update_frame)
    end

    it "should rotate the frame 90 with a projection rotation of 180" do
      @table.connect(:app => "app64", :rotation => 180)
      @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64_180)
      @app64.update_display(FrameFixtures.frame64)
      @table.send(:update_frame)
    end

    it "should rotate the frame 90 with a projection rotation of 270" do
      @table.connect(:app => "app64", :rotation => 270)
      @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64_270)
      @app64.update_display(FrameFixtures.frame64)
      @table.send(:update_frame)
    end

    it "should invert the frame if the invert option is set to true" do
      @table.connect(:app => "app64", :invert => true)
      @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64_i)
      @app64.update_display(FrameFixtures.frame64)
      @table.send(:update_frame)
    end

    it "should both invert the frame and rotate it by 180 if both options are set" do
      @table.connect(:app => "app64", :rotation => 180, :invert => true)
      @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64_180_i)
      @app64.update_display(FrameFixtures.frame64)
      @table.send(:update_frame)
    end
  end

  describe "Given a 128 monome" do
    before(:each) do
      @table   = Table.new(:ignore_connection_validity => true)
      @table.add_monome(:io_file => 'foo/bar', :device => "128")
      @monome = @table.send(:monome)
    end

    describe "With two 64 apps" do
      before(:each) do
        @table.add_app(:device => 64, :name => "app64_1")
        @table.add_app(:device => 64, :name => "app64_2")
        @app64_1 = @table.send(:app, "app64_1")
        @app64_2 = @table.send(:app, "app64_2")
      end

      describe "When registered with the surface with no rotation in the projection" do
        before(:each) do
          @table.connect(:app => "app64_1", :quadrant => 1)
          @table.connect(:app => "app64_2", :quadrant => 2)
        end

        it "on updating the display of the first app, should only illuminate the first frame with no rotation applied" do
          @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64)
          @app64_1.update_display(FrameFixtures.frame64)
          @table.send(:update_frame)
        end

        it "on updating the display of the second app, should only illuminate the second frame with no rotation applied" do
          @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame64)
          @app64_2.update_display(FrameFixtures.frame64)
          @table.send(:update_frame)
        end
      end

      describe "When registered with the surface with one of rotation 90 and the other rotation 270 in theie projections" do
        before(:each) do
          @table.connect(:app => "app64_1", :quadrant => 1, :rotation => 90)
          @table.connect(:app => "app64_2", :quadrant => 2, :rotation => 270)
        end

        it "on updating the display of the first app, should only illuminate the first frame with no rotation applied" do
          @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame64_90)
          @app64_1.update_display(FrameFixtures.frame64)
          @table.send(:update_frame)
        end

        it "on updating the display of the second app, should only illuminate the second frame with no rotation applied" do
          @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame64_270)
          @app64_2.update_display(FrameFixtures.frame64)
          @table.send(:update_frame)
        end
      end
    end
  end
end
#    describe "With one 128 app" do
#      before(:each) do
#        @app128 = Application.new(:device => 128, :name => "app128")
#      end
#
#      describe "When registerest with the surface with no rotation in the projection" do
#        before(:each) do
#          @surface.connect(:app => @app128, :quadrants => [1,2])
#        end
#
#        it "on updating the display of the application, should illuminate both frames with no rotation applied" do
#          @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame128_1)
#          @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame128_2)
#
#          @app128.update_display(FrameFixtures.frame128_1, FrameFixtures.frame128_2)
#        end
#      end
#
#      describe "When registered with the surface with a projection rotation of 180" do
#        before(:each) do
#          @surface.connect(:app => @app128, :quadrants => [1,2], :rotation => 180)
#        end
#
#        it "on updating the display of the application, should illuminate both frames with the frames swapped and rotated by 180" do
#          @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame128_2_180)
#          @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame128_1_180)
#
#          @app128.update_display(FrameFixtures.frame128_1, FrameFixtures.frame128_2)
#        end
#      end
#    end
#  end
#
#
#  describe "Given a 256 monome with four 64 apps, two 128 apps and a 256 app" do
#    before(:each) do
#      @monome    = Monome.new(:io_file => 'foo/bar', :device => "256")
#      @surface   = @monome.fetch_surface(:base)
#
#      @app64_1  = Application.new(:device => 64,  :name => "app64_1")
#      @app64_2  = Application.new(:device => 64,  :name => "app64_2")
#      @app64_3  = Application.new(:device => 64,  :name => "app64_3")
#      @app64_4  = Application.new(:device => 64,  :name => "app64_4")
#      @app128_1 = Application.new(:device => 128, :name => "app128_1")
#      @app128_2 = Application.new(:device => 128, :name => "app128_2")
#      @app256   = Application.new(:device => 256, :name => "app256")
#    end
#
#    describe "when registering all four 64 apps onto different quadrants with no rotation applied" do
#      before(:each) do
#        @surface.connect(:app => @app64_1, :quadrant => 1)
#        @surface.connect(:app => @app64_2, :quadrant => 2)
#        @surface.connect(:app => @app64_3, :quadrant => 3)
#        @surface.connect(:app => @app64_4, :quadrant => 4)
#      end
#
#      it "on updating the display of the applications, should illuminate all frames with no rotation applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_1)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_2)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_3)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_4)
#
#        @app64_1.update_display(FrameFixtures.frame256_1)
#        @app64_2.update_display(FrameFixtures.frame256_2)
#        @app64_3.update_display(FrameFixtures.frame256_3)
#        @app64_4.update_display(FrameFixtures.frame256_4)
#      end
#    end
#
#    describe "when registering all four 64 apps onto different quadrants with different rotations applied" do
#      before(:each) do
#        @surface.connect(:app => @app64_1, :quadrant => 1)
#        @surface.connect(:app => @app64_2, :quadrant => 2, :rotation => 90)
#        @surface.connect(:app => @app64_3, :quadrant => 3, :rotation => 180)
#        @surface.connect(:app => @app64_4, :quadrant => 4, :rotation => 270)
#      end
#
#      it "on updating the display of the applications, should illuminate all frames with the correct rotations applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_1)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_2_90)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_3_180)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_4_270)
#
#        @app64_1.update_display(FrameFixtures.frame256_1)
#        @app64_2.update_display(FrameFixtures.frame256_2)
#        @app64_3.update_display(FrameFixtures.frame256_3)
#        @app64_4.update_display(FrameFixtures.frame256_4)
#      end
#    end
#
#    describe "when registering  two 64 apps and one horizontal 128 app onto different quadrants no rotation applied" do
#      before(:each) do
#        @surface.connect(:app => @app64_1,  :quadrant => 1)
#        @surface.connect(:app => @app64_2,  :quadrant => 2)
#        @surface.connect(:app => @app128_1, :quadrants => [3,4])
#      end
#
#      it "on updating the display of the applications, should illuminate all frames with no rotations applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_1)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_2)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_3)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_4)
#
#        @app64_1.update_display(FrameFixtures.frame256_1)
#        @app64_2.update_display(FrameFixtures.frame256_2)
#        @app128_1.update_display(FrameFixtures.frame256_3, FrameFixtures.frame256_4)
#      end
#    end
#
#    describe "when registering two 64 apps and one vertial 128 app onto different quadrants no rotation applied" do
#      before(:each) do
#        @surface.connect(:app => @app64_1,  :quadrant => 4)
#        @surface.connect(:app => @app64_2,  :quadrant => 2)
#        @surface.connect(:app => @app128_1, :quadrants => [1,3])
#      end
#
#      it "on updating the display of the applications, should illuminate all frames with no rotation for the 64 and a rotation of 90 for the 128 (as it's on its side)" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame128_1_90)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_2)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame128_2_90)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_1)
#
#        @app64_1.update_display(FrameFixtures.frame256_1)
#        @app64_2.update_display(FrameFixtures.frame256_2)
#        @app128_1.update_display(FrameFixtures.frame128_1, FrameFixtures.frame128_2)
#      end
#    end
#
#    describe "when registering two 64 apps and one vertical 128 app onto different quadrants with various rotations applied" do
#      before(:each) do
#        @surface.connect(:app => @app64_1,  :quadrant => 4, :rotation => 270)
#        @surface.connect(:app => @app64_2,  :quadrant => 2, :rotation => 90)
#        @surface.connect(:app => @app128_1, :quadrants => [1,3], :rotation => 180)
#      end
#
#      it "on updating the display of the applications, should illuminate all frames with no rotations applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame128_2_270)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_2_90)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame128_1_270)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_1_270)
#
#        @app64_1.update_display(FrameFixtures.frame256_1)
#        @app64_2.update_display(FrameFixtures.frame256_2)
#        @app128_1.update_display(FrameFixtures.frame128_1, FrameFixtures.frame128_2)
#      end
#    end
#
#    describe "when registering two 128 apps horizontally onto different quadrants with no rotation applied" do
#      before(:each) do
#        @surface.connect(:app => @app128_1, :quadrants => [1,2])
#        @surface.connect(:app => @app128_2, :quadrants => [3,4])
#      end
#
#      it "on updating the display of the applications, should illuminat all frames with no rotations applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_1)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_2)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_3)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_4)
#
#
#        @app128_1.update_display(FrameFixtures.frame256_1, FrameFixtures.frame256_2)
#        @app128_2.update_display(FrameFixtures.frame256_3, FrameFixtures.frame256_4)
#      end
#    end
#
#    describe "when registering two 128 apps horizontally onto different quadrants with different rotations applied" do
#      before(:each) do
#        @surface.connect(:app => @app128_1, :quadrants => [1,2], :rotation => 180)
#        @surface.connect(:app => @app128_2, :quadrants => [3,4], :rotation => 0)
#      end
#
#      it "on updating the display of the applications, should illuminat all frames with no rotations applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_2_180)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_1_180)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_3)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_4)
#
#
#        @app128_1.update_display(FrameFixtures.frame256_1, FrameFixtures.frame256_2)
#        @app128_2.update_display(FrameFixtures.frame256_3, FrameFixtures.frame256_4)
#      end
#    end
#
#    describe "when registering two 128 apps vertically onto different quadrants with no rotation applied" do
#      before(:each) do
#        @surface.connect(:app => @app128_1, :quadrants => [1,3])
#        @surface.connect(:app => @app128_2, :quadrants => [2,4])
#      end
#
#      it "on updating the display of the applications, should illuminat all frames with rotation 90 applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_1_90)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame128_1_90)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_2_90)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame128_2_90)
#
#
#        @app128_1.update_display(FrameFixtures.frame256_1, FrameFixtures.frame256_2)
#        @app128_2.update_display(FrameFixtures.frame128_1, FrameFixtures.frame128_2)
#      end
#    end
#
#    describe "when registering two 128 apps vertically onto different quadrants with different rotations applied" do
#      before(:each) do
#        @surface.connect(:app => @app128_1, :quadrants => [1,3], :rotation => 180)
#        @surface.connect(:app => @app128_2, :quadrants => [2,4], :rotation => 0)
#      end
#
#      it "on updating the display of the applications, should illuminat all frames with rotation 90 applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_2_270)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame128_1_90)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_1_270)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame128_2_90)
#
#
#        @app128_1.update_display(FrameFixtures.frame256_1, FrameFixtures.frame256_2)
#        @app128_2.update_display(FrameFixtures.frame128_1, FrameFixtures.frame128_2)
#      end
#    end
#
#    describe "when registering one 256 app with no rotations applied" do
#      before(:each) do
#        @surface.connect(:app => @app256, :quadrants => [1,2,3,4])
#      end
#
#      it "on updating the display of the application, should illuminate all frames with no rotation applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_1)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_2)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_3)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_4)
#
#        @app256.update_display(FrameFixtures.frame256_1,FrameFixtures.frame256_2,FrameFixtures.frame256_3,FrameFixtures.frame256_4)
#      end
#    end
#
#    describe "when registering one 256 app with 90 rotation applied" do
#      before(:each) do
#        @surface.connect(:app => @app256, :quadrants => [1,2,3,4], :rotation => 90)
#      end
#
#      it "on updating the display of the application, should illuminate all frames with no rotation applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_3_90)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_1_90)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_4_90)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_2_90)
#
#        @app256.update_display(FrameFixtures.frame256_1,FrameFixtures.frame256_2,FrameFixtures.frame256_3,FrameFixtures.frame256_4)
#      end
#    end
#
#    describe "when registering one 256 app with 180 rotation applied" do
#      before(:each) do
#        @surface.connect(:app => @app256, :quadrants => [1,2,3,4], :rotation => 180)
#      end
#
#      it "on updating the display of the application, should illuminate all frames with no rotation applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_4_180)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_3_180)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_2_180)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_1_180)
#
#        @app256.update_display(FrameFixtures.frame256_1,FrameFixtures.frame256_2,FrameFixtures.frame256_3,FrameFixtures.frame256_4)
#      end
#    end
#
#    describe "when registering one 256 app with 270 rotation applied" do
#      before(:each) do
#        @surface.connect(:app => @app256, :quadrants => [1,2,3,4], :rotation => 270)
#      end
#
#      it "on updating the display of the application, should illuminate all frames with no rotation applied" do
#        @monome.should_receive(:light_quadrant).with(1, FrameFixtures.frame256_2_270)
#        @monome.should_receive(:light_quadrant).with(2, FrameFixtures.frame256_4_270)
#        @monome.should_receive(:light_quadrant).with(3, FrameFixtures.frame256_1_270)
#        @monome.should_receive(:light_quadrant).with(4, FrameFixtures.frame256_3_270)
#
#        @app256.update_display(FrameFixtures.frame256_1,FrameFixtures.frame256_2,FrameFixtures.frame256_3,FrameFixtures.frame256_4)
#      end
#    end
#  end
#end
