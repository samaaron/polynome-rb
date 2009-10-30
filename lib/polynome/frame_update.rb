module Polynome
  class FrameUpdate
    attr_reader :application, :frames
    def initialize(application, frames)
      @application = application
      @frames      = frames
    end
  end
end
