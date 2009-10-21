
require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Polynome::FrameFixtures do
  describe "frame -> bit array -> bit string mapping" do

    describe "all lit" do
      it "should be sane" do
        frame = Frame.new(FrameFixtures.all_lit_string)
        frame.read.should == FrameFixtures.all_lit_array
        frame.should == FrameFixtures.all_lit_frame
      end
    end

    describe "blank" do
      it "should be sane" do
        frame = Frame.new(FrameFixtures.blank_string)
        frame.read.should == FrameFixtures.blank_array
        frame.should == FrameFixtures.blank_frame
      end
    end

    describe "64 frame 1" do
      describe "with 0 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string64)
          frame.read.should == FrameFixtures.bit_array64
          frame.should == FrameFixtures.frame64
        end
      end

      describe "with 90 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string64_90)
          frame.read.should == FrameFixtures.bit_array64_90
          frame.should == FrameFixtures.frame64_90
          frame.should == FrameFixtures.frame64.rotate!(90)
        end
      end

      describe "with 180 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string64_180)
          frame.read.should == FrameFixtures.bit_array64_180
          frame.should == FrameFixtures.frame64_180
          frame.should == FrameFixtures.frame64.rotate!(180)
        end
      end

      describe "with 270 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string64_270)
          frame.read.should == FrameFixtures.bit_array64_270
          frame.should == FrameFixtures.frame64_270
          frame.should == FrameFixtures.frame64.rotate!(270)
        end
      end
    end


    describe "128 frame 1" do
      describe "with 0 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string128_1)
          frame.read.should == FrameFixtures.bit_array128_1
          frame.should == FrameFixtures.frame128_1
        end
      end

      describe "with 90 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string128_1_90)
          frame.read.should == FrameFixtures.bit_array128_1_90
          frame.should == FrameFixtures.frame128_1_90
          frame.should == FrameFixtures.frame128_1.rotate!(90)
        end
      end

      describe "with 180 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string128_1_180)
          frame.read.should == FrameFixtures.bit_array128_1_180
          frame.should == FrameFixtures.frame128_1_180
          frame.should == FrameFixtures.frame128_1.rotate!(180)
        end
      end

      describe "with 270 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string128_1_270)
          frame.read.should == FrameFixtures.bit_array128_1_270
          frame.should == FrameFixtures.frame128_1_270
          frame.should == FrameFixtures.frame128_1.rotate!(270)
        end
      end
    end

    describe "128 frame 2" do
      describe "with 0 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string128_2)
          frame.read.should == FrameFixtures.bit_array128_2
          frame.should == FrameFixtures.frame128_2
        end
      end

      describe "with 90 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string128_2_90)
          frame.read.should == FrameFixtures.bit_array128_2_90
          frame.should == FrameFixtures.frame128_2_90
          frame.should == FrameFixtures.frame128_2.rotate!(90)
        end
      end

      describe "with 180 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string128_2_180)
          frame.read.should == FrameFixtures.bit_array128_2_180
          frame.should == FrameFixtures.frame128_2_180
          frame.should == FrameFixtures.frame128_2.rotate!(180)
        end
      end

      describe "with 270 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string128_2_270)
          frame.read.should == FrameFixtures.bit_array128_2_270
          frame.should == FrameFixtures.frame128_2_270
          frame.should == FrameFixtures.frame128_2.rotate!(270)
        end
      end
    end

    describe "256 frame 1" do
      describe "with 0 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_1)
          frame.read.should == FrameFixtures.bit_array256_1
          frame.should == FrameFixtures.frame256_1
        end
      end

      describe "with 90 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_1_90)
          frame.read.should == FrameFixtures.bit_array256_1_90
          frame.should == FrameFixtures.frame256_1_90
          frame.should == FrameFixtures.frame256_1.rotate!(90)
        end
      end

      describe "with 180 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_1_180)
          frame.read.should == FrameFixtures.bit_array256_1_180
          frame.should == FrameFixtures.frame256_1_180
          frame.should == FrameFixtures.frame256_1.rotate!(180)
        end
      end

      describe "with 270 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_1_270)
          frame.read.should == FrameFixtures.bit_array256_1_270
          frame.should == FrameFixtures.frame256_1_270
          frame.should == FrameFixtures.frame256_1.rotate!(270)
        end
      end
    end

    describe "256 frame 2" do
      describe "with 0 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_2)
          frame.read.should == FrameFixtures.bit_array256_2
          frame.should == FrameFixtures.frame256_2
        end
      end

      describe "with 90 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_2_90)
          frame.read.should == FrameFixtures.bit_array256_2_90
          frame.should == FrameFixtures.frame256_2_90
          frame.should == FrameFixtures.frame256_2.rotate!(90)
        end
      end

      describe "with 180 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_2_180)
          frame.read.should == FrameFixtures.bit_array256_2_180
          frame.should == FrameFixtures.frame256_2_180
          frame.should == FrameFixtures.frame256_2.rotate!(180)
        end
      end

      describe "with 270 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_2_270)
          frame.read.should == FrameFixtures.bit_array256_2_270
          frame.should == FrameFixtures.frame256_2_270
          frame.should == FrameFixtures.frame256_2.rotate!(270)
        end
      end
    end

    describe "256 frame 3" do
      describe "with 0 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_3)
          frame.read.should == FrameFixtures.bit_array256_3
          frame.should == FrameFixtures.frame256_3
        end
      end

      describe "with 90 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_3_90)
          frame.read.should == FrameFixtures.bit_array256_3_90
          frame.should == FrameFixtures.frame256_3_90
          frame.should == FrameFixtures.frame256_3.rotate!(90)
        end
      end

      describe "with 180 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_3_180)
          frame.read.should == FrameFixtures.bit_array256_3_180
          frame.should == FrameFixtures.frame256_3_180
          frame.should == FrameFixtures.frame256_3.rotate!(180)
        end
      end

      describe "with 270 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_3_270)
          frame.read.should == FrameFixtures.bit_array256_3_270
          frame.should == FrameFixtures.frame256_3_270
          frame.should == FrameFixtures.frame256_3.rotate!(270)
        end
      end
    end

    describe "256 frame 4" do
      describe "with 0 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_4)
          frame.read.should == FrameFixtures.bit_array256_4
          frame.should == FrameFixtures.frame256_4
        end
      end

      describe "with 90 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_4_90)
          frame.read.should == FrameFixtures.bit_array256_4_90
          frame.should == FrameFixtures.frame256_4_90
          frame.should == FrameFixtures.frame256_4.rotate!(90)
        end
      end

      describe "with 180 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_4_180)
          frame.read.should == FrameFixtures.bit_array256_4_180
          frame.should == FrameFixtures.frame256_4_180
          frame.should == FrameFixtures.frame256_4.rotate!(180)
        end
      end

      describe "with 270 degree rotation" do
        it "should be sane" do
          frame = Frame.new(FrameFixtures.bit_string256_4_270)
          frame.read.should == FrameFixtures.bit_array256_4_270
          frame.should == FrameFixtures.frame256_4_270
          frame.should == FrameFixtures.frame256_4.rotate!(270)
        end
      end
    end
  end
end
