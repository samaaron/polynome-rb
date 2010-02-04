module ThreadedLogger
  class TLogger
    attr_reader :name, :num_messages_received, :num_messages_logged

    def initialize(name, outstream)
      @name = name.to_s

      if IO === outstream
        @outstream = outstream
      else
        @outstream = File.open(outstream, 'a')
      end

      @messages = Queue.new
      @semaphore = Mutex.new
      @num_messages_received = 0
      @num_messages_logged = 0
      @running = false
      start
    end

    def time_stamp
      time = Time.now
      "#{time.hour}:#{time.min}:#{time.sec}:#{time.usec}"
    end

    def log(message)
      @semaphore.synchronize do
        @messages << message
        @num_messages_received += 1
      end
    end

    def <<(message)
      @semaphore.synchronize do
        @messages << message
        @num_messages_received += 1
      end
    end

    def length
      @messages.length
    end

    def outstream
      @outstream
    end

    def running?
      @running
    end

    def stop
      @thread.kill
      @running = false
      self
    end

    private
    def start
      @running = true
      @thread = Thread.new do
        loop do
          message = @messages.pop
          stamped_message = "[#{time_stamp}]".ljust(20) + " #{@name} #{message}\n"

          if((@outstream == STDOUT || @outstream == STDERR) && "".respond_to?(:color))
            #we're printing out to STDOUT or STDERR and we have the
            #rainbow gem installed, so make it pretty, pretty blue
            @outstream << stamped_message.color(:blue)
          else
            @outstream << stamped_message
          end

          @outstream.flush
          @num_messages_logged += 1
        end
      end
    end
  end
end
