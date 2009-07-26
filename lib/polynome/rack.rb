module Polynome
  class Rack
    def initialize(opts={})
      opts.reverse_merge!(:in_port => 4433)
      @listener = OSCListener.new(opts[:in_port])
    end
  end
end
