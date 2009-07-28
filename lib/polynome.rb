$:.push File.dirname(__FILE__) + '/../vendor/rosc/lib'
$:.push File.dirname(__FILE__) + '/../vendor/activesupport/lib'
$:.push File.dirname(__FILE__) + '/polynome'

#require vendored stuff
require 'osc'
require 'activesupport'

#require polynome stuff
require 'rack'
require 'osc_listener'
require 'osc_sender'
