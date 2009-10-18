require File.dirname(__FILE__) + '/../lib/polynome'
include Polynome


m = Monome.new(:io_file => '/dev/tty.usbserial-m256-203', :model => "256")

blank = Frame.new("0000000000000000000000000000000000000000000000000000000000000000")

test64 =
"00000000"\
"11100010"\
"10000110"\
"10001010"\
"11101111"\
"10100010"\
"11100010"\
"00000000"

f = Frame.new(test64)

m.update_frame_buffer(f, blank, blank, blank)
