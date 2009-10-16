require File.dirname(__FILE__) + '/../spec_helper.rb'
include Polynome

describe Monome do

  it "should point to the correct constant from this namespace" do
    Monome.should == Polynome::Monome
  end

  describe "#initialize" do
    it "should raise an ArgumentError if an unknown cable orientation is specified" do
      lambda{Monome.new(:io_file => 'foo/bar', :model => "256", :cable_orientation => "wireless (dream on)")}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no io_file is specified" do
      lambda{Monome.new(:model => "256")}.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if no model is specified" do
      lambda{Monome.new(:io_file => 'foo/bar')}.should raise_error(ArgumentError)
    end
  end

  describe "with a default Monome of model 256" do
    before(:each) do
      @monome = Monome.new(:io_file => 'foo/bar', :model => "256")
    end

    it "should have a cable orientation of top" do
      @monome.cable_orientation.should == :top
    end

    it "should have kind TwoFiftySix" do
      @monome.model.should be_kind_of(TwoFiftySix)
    end

    it "should have 4 frame buffers" do
      @monome.num_frame_buffers.should == 4
    end

    it "should start with 1 surface" do
      @monome.num_surfaces.should == 1
    end

    describe "#add_surface" do
      it "should be possible to add a surface with a given name" do
        lambda{@monome.add_surface(:new_surface)}.should_not raise_error
      end

      it "should return the surface just created" do
        surface = @monome.add_surface(:new_surface)
        surface.class.should == Surface
        surface.name.should == "new_surface"
      end

      it "should have one more surface after adding a surface" do
        num_surfaces = @monome.num_surfaces
        @monome.add_surface(:new_surface)
        @monome.num_surfaces.should == num_surfaces + 1
      end

      it "should raise an error if the surface name already exists" do
        @monome.add_surface(:duplicate_surface)
        lambda{@monome.add_surface(:duplicate_surface)}.should raise_error(Surface::DuplicateSurfaceError)
      end
    end

    describe "#remove_surface" do
      before(:each) do
        @monome.add_surface(:new_surface)
      end

      it "should be possible to remove a surface" do
        lambda{@monome.remove_surface(:new_surface)}.should_not raise_error
      end

      it "should return the surface just removed" do
        surface = @monome.remove_surface(:new_surface)
        surface.class.should == Surface
        surface.name.should == "new_surface"
      end

      it "should have one fewer surfaces after removing a surface" do
        num_surfaces = @monome.num_surfaces
        @monome.remove_surface(:new_surface)
        @monome.num_surfaces.should == num_surfaces - 1
      end

      it "should raise an error if the surface requested for removal doesn't exist" do
        lambda{@monome.remove_surface(:unknown_surface)}.should raise_error(Surface::UnknownSurfaceError)
      end
    end

    describe "#fetch_surface" do
      it "should be possible to fetch the base surface (which is also the initial 'current_surface')" do
        base_surface = @monome.current_surface
        @monome.fetch_surface("base").should == base_surface
      end

      it "should raise an error if the surface name is unknown" do
        lambda{@monome.fetch_surface("eggs")}.should raise_error(Surface::UnknownSurfaceError)
      end

      it "should be possible to fetch a surface we've just added (using a symbol)" do
        fred = @monome.add_surface(:fred)
        @monome.fetch_surface(:fred).should == fred
      end
    end

    describe "#switch_to_surface" do
      before(:each) do
        @ioke    = @monome.add_surface(:ioke)
        @erlang  = @monome.add_surface(:erlang)
        @clojure = @monome.add_surface(:clojure)
      end

      it "should raise an error if the surface name is unknown" do
        lambda{@monome.switch_to_surface(:beans)}.should raise_error(Surface::UnknownSurfaceError)
      end

      it "should be possible to switch to the ioke surface" do
        @monome.switch_to_surface(:ioke)
        @monome.current_surface.should == @ioke
      end

      it "should be possible to switch to the erlang surface" do
        @monome.switch_to_surface(:erlang)
        @monome.current_surface.should == @erlang
      end

      it "should be possible to switch to the clojure surface" do
        @monome.switch_to_surface(:clojure)
        @monome.current_surface.should == @clojure
      end
    end

    describe "#next_surface" do
      it "should just keep switching to base if no other surfaces exist" do
        base = @monome.fetch_surface(:base)
        @monome.current_surface.should == base
        @monome.next_surface
        @monome.current_surface.should == base
        @monome.next_surface
        @monome.current_surface.should == base
      end

      describe "with three other surfaces" do
        before(:each) do
          @base    = @monome.fetch_surface(:base)
          @ioke    = @monome.add_surface(:ioke)
          @erlang  = @monome.add_surface(:erlang)
          @clojure = @monome.add_surface(:clojure)
        end

        it "should switch round in a continuous loop" do
          @monome.current_surface.should == @base
          @monome.next_surface
          @monome.current_surface.should == @ioke
          @monome.next_surface
          @monome.current_surface.should == @erlang
          @monome.next_surface
          @monome.current_surface.should == @clojure
        end
      end
    end

    describe "#previous_surface" do
      it "should just keep switching to base if no other surfaces exist" do
        base = @monome.fetch_surface(:base)
        @monome.current_surface.should == base
        @monome.previous_surface
        @monome.current_surface.should == base
        @monome.previous_surface
        @monome.current_surface.should == base
      end

      describe "with three other surfaces" do
        before(:each) do
          @base    = @monome.fetch_surface(:base)
          @ioke    = @monome.add_surface(:ioke)
          @erlang  = @monome.add_surface(:erlang)
          @clojure = @monome.add_surface(:clojure)
        end

        it "should switch round in a continuous loop" do
          @monome.current_surface.should == @base
          @monome.previous_surface
          @monome.current_surface.should == @clojure
          @monome.previous_surface
          @monome.current_surface.should == @erlang
          @monome.previous_surface
          @monome.current_surface.should == @ioke
        end
      end
    end
  end
end
