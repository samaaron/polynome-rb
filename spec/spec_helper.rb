#require polynome
require File.dirname(__FILE__) + '/../lib/polynome'

#require oscpec, the OSC speccing tool
require File.dirname(__FILE__) + '/../vendor/tosca/lib/tosca'

#require rspec
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../vendor/rspec/lib'
require 'spec'
require 'spec/autorun'
