require 'thread'
require 'threaded_logger/tlogger'

module ThreadedLogger
  class CreateLogException < Exception ; end

  def self.reset
    initialize
  end

  def self.initialize
    @logs = {}
  end

  #make sure ThreadedLogger is initialized
  initialize


  #Strips the logging info noise from a stream.
  #i.e. a line like: "[ted, 1.45 3s] hey there\n"
  #is stripped to "hey there\n"
  #
  #The method also accepts a name parameter which will filter the
  #messages to those that match the name
  #(the stream must must respond to #to_s)
  #
  #This method is useful in tests
  def self.strip_messages(stream, name = nil)
    unstripped = stream.to_s
    log_name  = name ? name.to_s : ".*?"

    stream.split("\n").map{|msg| msg.match(/\[#{log_name}.*?\]\s*(.*)/)}.map{|match| match[1] if match}.compact.join("\n") + "\n"
  end

  #TODO: remove all these class methods if they're not being used
  def self.logs
    @logs.values
  end

  def self.create_log(name, outstream=STDOUT)
    raise(CreateLogException, "Error, attempting to create a log (#{name}) that already exists.") if @logs[name.to_s]
    unless @logs[name.to_s]
      log = TLogger.new(name.to_s, outstream)
      @logs[name.to_s] = log
    end

    return @logs[name.to_s]
  end

  def self.get_log(name)
    @logs[name.to_s]
  end
end
