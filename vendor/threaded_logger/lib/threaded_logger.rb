class ThreadedLogger
  def self.reset
    initialize
  end

  def self.log(message)
    @semaphore.synchronize do
      @messages << message
      @num_messages_received += 1
    end
  end

  def self.length
    @semaphore.synchronize do
      @messages.length
    end
  end

  def self.outstream=(outstream=STDOUT)
    @semaphore.synchronize do
      @outstream = outstream
    end
  end

  def self.outstream
    @semaphore.synchronize do
      @outstream
    end
  end

  def self.num_messages_received
    @semaphore.synchronize do
      @num_messages
    end
  end

  def self.num_messages_logged
    @semaphore.synchronize do
      @num_messages_logged
    end
  end

  def self.initialize
    @messages = Queue.new
    @outstream = STDOUT
    @semaphore = Mutex.new
    @num_messages_received = 0
    @num_messages_logged = 0
  end

  def self.start
    @thread = Thread.new do
      loop do
        @outstream << "#{@messages.pop}\n"
        @num_messages_logged += 1
      end
    end
  end

  def self.stop
    @thread.kill
  end

  initialize
end
