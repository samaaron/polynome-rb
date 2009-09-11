module MonomeSerial
  module SerialCommunicator
    def self.get_communicator(tty_path, verbose=true)
      begin
        raise IOError  unless File.exists?(tty_path)
        raise RuntimeError unless (RUBY_VERSION.split('.').join.to_i >= 191) && (Object.const_defined?("RUBY_ENGINE") && Object.const_get("RUBY_ENGINE") == "ruby")
        require 'termios'
        return RealCommunicator.new(tty_path)
      rescue IOError
        puts "Supplied path tty IO file isn't valid, loading up DummyCommunicator instead of a real one" if verbose
        return DummyCommunicator.new
      rescue RuntimeError
        puts "Incorrect Ruby version (want MRI Ruby 1.9.1 or higher), loading up DummyCommunicator instead of a real one" if verbose
        return DummyCommunicator.new
      rescue LoadError
        puts "Could not load the termios extension. Please install it. Loading up DummyCommunicator instead of a real one" if verbose
        return DummyCommunicator.new
      end
    end
  end
end
