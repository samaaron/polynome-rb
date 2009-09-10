#require polynome
require 'polynome'

#require tosca, the OSC speccing tool
require 'tosca'

#require rspec
require 'spec'
require 'spec/autorun'

ThreadedLogger.create_log(:rspec) unless ThreadedLogger.get_log(:rspec)
TLOG = ThreadedLogger.get_log(:rspec) unless defined? TLOG
