#require standard libraries
require 'thread'

#make sure vendored stuff takes priority in the loadpath
Dir[File.dirname(__FILE__) + '/../vendor/*/lib'].each {|lib|  $:.unshift lib}

#make sure extensions dir is in the loadpath
RUBY_ENGINE = 'MRI' unless Object.const_defined? "RUBY_ENGINE"
$:.unshift(File.dirname(__FILE__) + "/../vendor/extensions/#{RUBY_ENGINE}-#{RUBY_VERSION}-#{RUBY_PLATFORM}")

#require vendored stuff
require 'samaaron-rosc'
require 'activesupport'
require 'threaded_logger'
require 'rainbow'
require 'monome_serial'


#add self to the loadpath
$:.unshift File.dirname(__FILE__)
#require polynome stuff
require 'polynome/buttons'
require 'polynome/interface'
require 'polynome/frame_buffer'
require 'polynome/display'
require 'polynome/surface'
require 'polynome/frame'
require 'polynome/transposer'
require 'polynome/model'
require 'polynome/monome'
require 'polynome/loggable'
require 'polynome/rack'
require 'polynome/osc_listener'
require 'polynome/osc_sender'
require 'polynome/light_bank'


#require config
require 'polynome/../../config/defaults'

