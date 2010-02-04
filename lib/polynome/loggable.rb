module Polynome
  module Loggable
    attr_reader :logger
    def log(*messages)
      if messages.empty?
        return puts @log_history
      end

      if @debug
        name_to_log = @logger_name || @name
        logger_char = @logger_char || '?'
        message = "#{logger_char[0..1]} :"
        command = messages.size > 1 ? messages.shift : "LOG"
        message << " #{command.upcase.ljust(10)} - "

        messages.each{|m| message << "#{m}" }
        time  = Time.now
        stamp = "#{time.hour}.#{time.min} #{time.sec}s"
        @log_history ||= ""
        @log_history << "[#{stamp}]".ljust(20) + "\t#{name_to_log.ljust(30)} - #{message}\n"
        @logger      << "#{name_to_log.ljust(30)} #{message}" if @logger
      end
    end
  end
end
