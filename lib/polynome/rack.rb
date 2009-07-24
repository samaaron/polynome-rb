module Polynome
  class Rack
    def initialize(opts={})
      opts.reverse_merge!(:in_port => 4433)
    end
  end
end
