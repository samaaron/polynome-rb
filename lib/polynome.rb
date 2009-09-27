#require standard libraries
require 'thread'

#make sure vendored stuff takes priority in the loadpath
Dir[File.dirname(__FILE__) + '/../vendor/*/lib'].each {|lib|  $:.unshift lib}

#make sure extensions dir is in the loadpath
RUBY_ENGINE = 'MRI' unless Object.const_defined? "RUBY_ENGINE"
$:.unshift(File.dirname(__FILE__) + "/../vendor/extensions/#{RUBY_ENGINE}-#{RUBY_VERSION}-#{RUBY_PLATFORM}")

if RUBY_VERSION == "1.8.6"
  #backport methods added in 1.8.7 until JRuby has a 1.8.7 compatible
  #release to test with
  module Enumerable
    def find_index(*args, &block)
      return index(*args) unless block_given?

      match = self.find(&block)
      self.index(match)
    end
  end
end

#require vendored stuff
require 'samaaron-rosc'
require 'activesupport'
require 'threaded_logger'
require 'rainbow'
require 'monome_serial'


#add self to the loadpath
$:.unshift File.dirname(__FILE__)


#require polynome stuff
require 'polynome/loggable'
require 'polynome/osc_listener'
require 'polynome/osc_sender'
require 'polynome/quadrants'
require 'polynome/buttons'
require 'polynome/interface'
require 'polynome/frame_buffer'
require 'polynome/display'
require 'polynome/surface'
require 'polynome/frame'
require 'polynome/model'
require 'polynome/monome'
require 'polynome/light_bank'
require 'polynome/transposer'
require 'polynome/app_connector'
require 'polynome/rack'



#require config
require 'polynome/../../config/defaults'

