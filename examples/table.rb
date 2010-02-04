#add polynome and fixture info to load path
$: << File.dirname(__FILE__) +  "/../lib"
$: << File.dirname(__FILE__) +  "/../spec"

#require polynome and fixtures
require 'polynome'
require 'fixtures/frame_fixtures'
include Polynome


table = Table.new
table.add_monome(
                 :io_file         => "/dev/tty.usbserial-m64-0790",
                 :device          => "64",
                 :cable_placement => :top
                 )
table.boot



#hang around for a bit
loop { sleep 0.1 }
