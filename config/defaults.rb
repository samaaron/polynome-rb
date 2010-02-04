#config options to be loaded up as default on boot

module Polynome
  module Defaults
    def self.set(var, value)
      (class << self ; self ; end).send(:define_method, var) {value}
    end

    set :root, File.expand_path(File.dirname(__FILE__) + '/../')
    set :table_outport, 9966
    set :table_inport, 6699
    set :test_table_outport, 9967
    set :test_table_inport, 6799
    set :outhost, 'localhost'
    set :debug?, true
    set :frame_buffer_size, 100
    set :log_file, "#{Polynome::Defaults.root}/log/activity.log"
    set :logger, ThreadedLogger::TLogger.new("", Defaults.log_file)
  end
end

