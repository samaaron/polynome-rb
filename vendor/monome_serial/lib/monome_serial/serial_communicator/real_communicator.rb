require 'termios'
module MonomeSerial
  module SerialCommunicator
    class RealCommunicator < Communicator
      attr_reader :model, :serial
      def initialize(tty_path)
        #make sure tty_path exists (such as "/dev/tty.usbserial-m256-203")
        raise ArgumentError, "path to tty IO file does not exist" unless File.exists?(tty_path)

        #match = tty_path.match /m(\d+)-(\d+)/
        #@model = match[1]

        #pull out this Monome's individual serial number
        #@serial = match[2]

        #Open up the virtual serial port
        @dev = dev_open(tty_path)

        #bless the file with Termios powers
        @dev.extend Termios

        #create a new Termios struct
        newtio = Termios::new_termios()
        newtio.iflag = Termios::IGNPAR
        newtio.oflag = 0
        newtio.cflag = Termios::CLOCAL
        newtio.lflag = 0
        newtio.cc[Termios::VTIME] = 0
        newtio.cc[Termios::VMIN] = 1
        newtio.ispeed = Termios::B115200
        newtio.ospeed = Termios::B115200

        #discard data on both the input and output queues
        flush

        #set the termios struct in the OS with the newly
        #defined info in newtio
        @dev.tcsetattr(Termios::TCSANOW, newtio)
      end

      def real?
        true
      end

      def read
        #read action message
        action_bin = @dev.read(1)

        #interpret action:
        #0000000 => keydown
        #0001000 => keyup
        action = action_bin.unpack('B8').first[3] == "1" ? :keyup : :keydown

        #read position message
        pos_bin    = @dev.read(1)

        #convert it to a binary string
        pos_bin_s = pos_bin.unpack('B8').first

        #interpret position:
        #xxxxyyyy => x position and y position in base 2
        x = Integer("0b" + pos_bin_s[0..3])
        y = Integer("0b" + pos_bin_s[4..8])

        return action, x, y
      end

      def write(strings)

        super

        #convert integer params to 8bit binary representation
        bin_strings = strings.map{|s| s.to_s}

        case bin_strings.size
        when 1 then @dev.write(bin_strings.pack('B8'))
        when 2 then @dev.write(bin_strings.pack('B8B8'))
        when 3 then @dev.write(bin_strings.pack('B8B8B8'))
        when 9 then @dev.write(bin_strings.pack('B8B8B8B8B8B8B8B8B8'))
        else raise ArgumentError, "SerialCommunicator#write only supports sending one, two, three or nine bytes at a time. You tried to send #{bin_strings.size} bytes."
        end
      end

      private

      def flush
        @dev.tcflush(Termios::TCIOFLUSH)
      end

      def dev_open(path)
        dev = open(path , File::RDWR | File::NONBLOCK)
        mode = dev.fcntl(Fcntl::F_GETFL, 0)
        dev.fcntl(Fcntl::F_SETFL, mode & ~File::NONBLOCK)
        return dev
      end
    end
  end
end
