module Polynome
  module Loggable
    def log(message)
      if @debug
        @log_history << "#{@name} #{message}"
        @logger      << "#{@name} #{message}" if @logger
      end
    end
  end
end
