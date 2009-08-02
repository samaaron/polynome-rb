#require standard libraries
require 'thread'

#require vendored stuff
$:.push File.dirname(__FILE__) + '/../vendor/rosc/lib'
$:.push File.dirname(__FILE__) + '/../vendor/activesupport/lib'
require 'osc'
require 'activesupport'

#require polynome stuff
$:.push File.dirname(__FILE__) + '/polynome'
require 'udp_server_with_count'
require 'rack'
require 'osc_listener'
require 'osc_sender'
require 'virtual_monome'

#require config
$:.push File.dirname(__FILE__) + '/../config'
require 'defaults'
