class ThreadedLogger
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

  def self.create_log(name)
    unless @logs[name.to_s]
      log = new(name.to_s)
      @logs[name.to_s] = log
    end
  end

  def self.get_log(name)
    @logs[name.to_s]
  end


  attr_reader :name

  def initialize(name)
    @name = name.to_s
    @messages = Queue.new
    @outstream = STDOUT
    @semaphore = Mutex.new
    @num_messages_received = 0
    @num_messages_logged = 0
    @running = false
  end

  def log(message)
    @semaphore.synchronize do
      @messages << message
      @num_messages_received += 1
    end
  end

  def time_stamp
    time = Time.now
    "#{time.hour}.#{time.min} #{time.sec}s"
  end

  def <<(message)
    log(message)
  end

  def length
    @semaphore.synchronize do
      @messages.length
    end
  end

  def outstream=(outstream=STDOUT)
    @semaphore.synchronize do
      @outstream = outstream
    end
  end

  def outstream
    @semaphore.synchronize do
      @outstream
    end
  end

  def num_messages_received
    @semaphore.synchronize do
      @num_messages
    end
  end

  def num_messages_logged
    @semaphore.synchronize do
      @num_messages_logged
    end
  end

  def start
    @semaphore.synchronize do
      @running = true
      @thread = Thread.new do
        loop do
          message = @messages.pop
          @outstream << "[#{@name}, #{time_stamp}] #{message}\n"
          @num_messages_logged += 1
        end
      end
    end
  end

  def running?
    @semaphore.synchronize do
      @running
    end
  end

  def stop
    @semaphore.synchronize do
      @thread.kill
      @running = false
    end
  end
end
