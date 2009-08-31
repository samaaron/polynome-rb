#TODO work out a nice way not to require this
#(perhaps by converting samaaron-rosc to a gem)
$:.unshift File.dirname(__FILE__) + '/../../samaaron-rosc/lib'

require 'samaaron-rosc'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/tosca'
require 'receiver'
require 'sender'
