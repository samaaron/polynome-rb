
# Force the libs onto the load path for the sake of autospec
$: << File.dirname(__FILE__) +  "/../vendor/threaded_logger/lib/"
$: << File.dirname(__FILE__) +  "/../lib"
$: << File.dirname(__FILE__) +  "/../vendor/tosca/lib"
$: << File.dirname(__FILE__) +  "/../vendor/monome_serial/lib/"
$: << File.dirname(__FILE__) +  "/../vendor/activesupport/lib"
RUBY_ENGINE = 'MRI' unless Object.const_defined?("RUBY_ENGINE")
$: << File.dirname(__FILE__) +  "/../vendor/extensions/#{RUBY_ENGINE}-#{RUBY_VERSION}-#{RUBY_PLATFORM}"
$: << File.dirname(__FILE__)
#require polynome
require 'polynome'

#require tosca, the OSC speccing tool
require 'tosca'

#require rspec
require 'spec'
require 'spec/autorun'

#require fixtures
require 'fixtures/frame_fixtures'

ThreadedLogger.create_log(:rspec) unless ThreadedLogger.get_log(:rspec)
TLOG = ThreadedLogger.get_log(:rspec) unless defined? TLOG
MonomeSerial::SerialCommunicator.suppress_warnings = true
