
#require standard libraries
require 'thread'
Thread.abort_on_exception = true

#make sure vendored stuff takes priority in the loadpath
Dir[File.dirname(__FILE__) + '/../vendor/*/lib'].each {|lib|  $:.unshift lib}

#make sure extensions dir is in the loadpath
RUBY_ENGINE = 'MRI' unless Object.const_defined? "RUBY_ENGINE"
$:.unshift(File.dirname(__FILE__) + "/../vendor/extensions/#{RUBY_ENGINE}-#{RUBY_VERSION}-#{RUBY_PLATFORM}")

raise "Ruby 1.8.6 is not supported. Please use 1.8.7 or higher" if RUBY_VERSION == "1.8.6"

#require vendored stuff
require 'samaaron-rosc'
require 'active_support'
require 'threaded_logger'
require 'rainbow'
require 'monome_serial'


#add self to the loadpath
$:.unshift File.dirname(__FILE__)


#require polynome stuff
require 'polynome/loggable'
require 'polynome/osc_prefix'
require 'polynome/osc_listener'
require 'polynome/osc_sender'
require 'polynome/quadrants'
require 'polynome/projection'
require 'polynome/surface'
require 'polynome/carousel'
require 'polynome/frame'
require 'polynome/model/generic_model'
require 'polynome/model/fourtyh'
require 'polynome/model/sixty_four'
require 'polynome/model/one_twenty_eight_generic'
require 'polynome/model/one_twenty_eight_landscape'
require 'polynome/model/one_twenty_eight_portrait'
require 'polynome/model/two_fifty_six'
require 'polynome/model'
require 'polynome/frame_update'
require 'polynome/monome'
require 'polynome/layer'
require 'polynome/light_bank'
require 'polynome/application'
require 'polynome/rack'
require 'polynome/table'
require 'polynome/client'


#require config
require 'polynome/../../config/defaults'

