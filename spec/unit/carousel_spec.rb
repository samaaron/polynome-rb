require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Carousel do
  it "should resolve to the correct constant from this context" do
    Polynome::Carousel.should == Carousel
  end

  describe "with a newly initialised carousel" do
    before(:each) do
      @carousel = Carousel.new(Monome.new(:io_file => 'foo/bar', :model => "256"))
    end

    describe "#add" do
      it "should be possible to add a surface with a given name" do
        lambda{@carousel.add(:new)}.should_not raise_error
      end

      it "should return the surface just created" do
        surface = @carousel.add(:new)
        surface.class.should == Surface
        surface.name.should == "new"
      end

      it "should have one more surface after adding a surface" do
        size = @carousel.size
        @carousel.add(:new)
        @carousel.size.should == size + 1
      end

      it "should raise an error if the surface name already exists" do
        @carousel.add(:duplicate)
        lambda{@carousel.add(:duplicate)}.should raise_error(Surface::DuplicateSurfaceError)
      end
    end

    describe "#remove" do
      before(:each) do
        @carousel.add(:new)
      end

      it "should be possible to remove a surface" do
        lambda{@carousel.remove(:new)}.should_not raise_error
      end

      it "should return the surface just removed" do
        surface = @carousel.remove(:new)
        surface.class.should == Surface
        surface.name.should == "new"
      end

      it "should have one fewer surfaces after removing a surface" do
        size = @carousel.size
        @carousel.remove(:new)
        @carousel.size.should == size - 1
      end

      it "should raise an error if the surface requested for removal doesn't exist" do
        lambda{@carousel.remove(:unknown)}.should raise_error(Surface::UnknownSurfaceError)
      end
    end

    describe "#fetch" do
      it "should be possible to fetch the base surface (which is also the initial 'current')" do
        base = @carousel.current
        @carousel.fetch("base").should == base
      end

      it "should raise an error if the surface name is unknown" do
        lambda{@carousel.fetch("eggs")}.should raise_error(Surface::UnknownSurfaceError)
      end

      it "should be possible to fetch a surface we've just added (using a symbol)" do
        fred = @carousel.add(:fred)
        @carousel.fetch(:fred).should == fred
      end
    end

    describe "#switch_to" do
      before(:each) do
        @ioke    = @carousel.add(:ioke)
        @erlang  = @carousel.add(:erlang)
        @clojure = @carousel.add(:clojure)
      end

      it "should raise an error if the surface name is unknown" do
        lambda{@carousel.switch_to(:beans)}.should raise_error(Surface::UnknownSurfaceError)
      end

      it "should be possible to switch to the ioke surface" do
        @carousel.switch_to(:ioke)
        @carousel.current.should == @ioke
      end

      it "should be possible to switch to the erlang surface" do
        @carousel.switch_to(:erlang)
        @carousel.current.should == @erlang
      end

      it "should be possible to switch to the clojure surface" do
        @carousel.switch_to(:clojure)
        @carousel.current.should == @clojure
      end
    end

    describe "#next" do
      it "should just keep switching to base if no other surfaces exist" do
        base = @carousel.fetch(:base)
        @carousel.current.should == base
        @carousel.next
        @carousel.current.should == base
        @carousel.next
        @carousel.current.should == base
      end

      describe "with three other surfaces" do
        before(:each) do
          @base    = @carousel.fetch(:base)
          @ioke    = @carousel.add(:ioke)
          @erlang  = @carousel.add(:erlang)
          @clojure = @carousel.add(:clojure)
        end

        it "should switch round in a continuous loop" do
          @carousel.current.should == @base
          @carousel.next
          @carousel.current.should == @ioke
          @carousel.next
          @carousel.current.should == @erlang
          @carousel.next
          @carousel.current.should == @clojure
        end
      end
    end

    describe "#previous" do
      it "should just keep switching to base if no other surfaces exist" do
        base = @carousel.fetch(:base)
        @carousel.current.should == base
        @carousel.previous
        @carousel.current.should == base
        @carousel.previous
        @carousel.current.should == base
      end

      describe "with three other surfaces" do
        before(:each) do
          @base    = @carousel.fetch(:base)
          @ioke    = @carousel.add(:ioke)
          @erlang  = @carousel.add(:erlang)
          @clojure = @carousel.add(:clojure)
        end

        it "should switch round in a continuous loop" do
          @carousel.current.should == @base
          @carousel.previous
          @carousel.current.should == @clojure
          @carousel.previous
          @carousel.current.should == @erlang
          @carousel.previous
          @carousel.current.should == @ioke
        end
      end
    end
  end
end
