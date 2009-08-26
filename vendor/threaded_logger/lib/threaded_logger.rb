class ThreadedLogger
  def self.reset
    initialize
  end

  def self.initialize
    @logs = {}
  end

  #make sure ThreadedLogger is initialized
  initialize

  def self.logs
    @logs.values
  end

  def self.create_log(name)
    log = new(name)
    @logs[name.to_s] = log
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
  end

  def log(message)
    @semaphore.synchronize do
      @messages << message
      @num_messages_received += 1
    end
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
    @thread = Thread.new do
      loop do
        @outstream << "#{@messages.pop}\n"
        @num_messages_logged += 1
      end
    end
  end

  def stop
    @thread.kill
  end

end
