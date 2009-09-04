#require standard libraries
require 'thread'

#make sure vendored stuff takes priority in the loadpath
Dir[File.dirname(__FILE__) + '/../vendor/*/lib'].each {|lib|  $:.unshift lib}

#require vendored stuff
require 'samaaron-rosc'
require 'activesupport'
require 'threaded_logger'
require 'rainbow'

#add self to the loadpath
$:.unshift File.dirname(__FILE__)
#require polynome stuff
require 'polynome/loggable'
require 'polynome/table'
require 'polynome/osc_listener'
require 'polynome/osc_sender'
require 'polynome/virtual_monome'


#require config
require 'polynome/../../config/defaults'

