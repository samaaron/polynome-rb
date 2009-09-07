module ThreadedLogger
  class TLogger
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
            stamped_message = "[#{@name}, #{time_stamp}]\t#{message}\n"

            if((@outstream == STDOUT || @outstream == STDERR) && "".respond_to?(:color))
              #we're printing out to STDOUT or STDERR and we have the
              #rainbow gem installed, so make it pretty, pretty blue
              @outstream << stamped_message.color(:blue)
            else
              @outstream << stamped_message
            end

            @num_messages_logged += 1
          end
        end
      end
      self
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
      self
    end
  end
end
