#require standard libraries
require 'thread'

#require vendored stuff
$:.unshift File.dirname(__FILE__) + '/../vendor/rosc/lib'
$:.unshift File.dirname(__FILE__) + '/../vendor/activesupport/lib'
require 'osc'
require 'activesupport'


#require polynome stuff
$:.unshift File.dirname(__FILE__) + '/polynome'
require 'udp_server_with_count'
require 'virtual_table'
require 'osc_listener'
require 'osc_sender'
require 'virtual_monome'
require 'threaded_logger'

#require config
$:.unshift File.dirname(__FILE__) + '/../config'
require 'defaults'
