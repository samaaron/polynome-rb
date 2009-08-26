#require standard libraries
require 'thread'

#require vendored stuff
$:.unshift File.dirname(__FILE__) + '/../vendor/rosc/lib'
$:.unshift File.dirname(__FILE__) + '/../vendor/activesupport/lib'
$:.unshift File.dirname(__FILE__) + '/../vendor/threaded_logger/lib'
require 'osc'
require 'activesupport'
require 'threaded_logger'

#require polynome stuff
$:.unshift File.dirname(__FILE__) + '/polynome'
require 'udp_server_with_count'
require 'table'
require 'osc_listener'
require 'osc_sender'
require 'virtual_monome'


#require config
$:.unshift File.dirname(__FILE__) + '/../config'
require 'defaults'
