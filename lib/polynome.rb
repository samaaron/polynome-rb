#require standard libraries
require 'thread'

#require vendored stuff
$:.unshift File.dirname(__FILE__) + '/../vendor/samaaron-rosc/lib'
$:.unshift File.dirname(__FILE__) + '/../vendor/activesupport/lib'
$:.unshift File.dirname(__FILE__) + '/../vendor/threaded_logger/lib'
require 'samaaron-rosc'
require 'activesupport'
require 'threaded_logger'

#require polynome stuff
$:.unshift File.dirname(__FILE__) + '/polynome'
require 'base'
require 'table'
require 'osc_listener'
require 'osc_sender'
require 'virtual_monome'


#require config
$:.unshift File.dirname(__FILE__) + '/../config'
require 'defaults'

