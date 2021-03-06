        , __       _
       /|/  \     | |
        |___/ __  | |        _  _    __   _  _  _    _
        |    /  \_|/  |   | / |/ |  /  \_/ |/ |/ |  |/
        |    \__/ |__/ \_/|/  |  |_/\__/   |  |  |_/|__/
                         /|
                         \|

  "letting multiple monome apps play and share together, nicely"



      +---------+                 ----- molar
      |ooooooooo|     +========+ /
      |ooooooooo| --- |Polynome| ------ mlr
      |ooooooooo|     +========+ \
      +---------+                 ----- Extended Emulator App


Polynome is still in a very early phase of development. The following
are the goals of the framework:

Polynome is a monome driver, extended emulator, switcher and splitter.

A Driver
--------
Polynome drives your monome. It communicates directly with it via the
USB serial port. Button presses are received from your monome and
Polynome sends signals to light its LEDs correctly.


An Extended Emulator
--------------------
Polynome presents the standard monome OSC protocol.
(http://opensoundcontrol.org/). This means that it's able to listen
and send all the standard monome OSC messages and react
appropriately. Polynome can therefore be connected with any currently
available monome application - just make sure the input/output ports
of the application match those you register with Polynome.

Polynome also provides extensions to the standard OSC messages for
more flexible control. This allows more powerful abstractions to be
used to manipulate the monome's LEDs.


A Switcher
----------
Polynome allows connections from more than one application. Each
connected application is assigned a virtual monome (called a
surface). Polynome provides mechanisms to select which surface is
currently displayed and therefore which application receives button
press and release signals at a given moment. Whilst an application's
surface is not currently active (i.e. driving the monome) it can still
receive signals from the connected application as if it were the real
monome.


A Splitter
----------
Polynome can split a monome to create multiple vitual monomes. For
example, a 256 could become two 128s or four 64s each assigned to its
own separate application.


What it is not
--------------

Polynome is not a typical monome application. The intention is that
application logic be written in separate applications. Either using
the standard monome OSC interface, or the extended emulator
interface. Polynome doesn't have an internal timer, midi interface,
music generator, or anything really very fun. Polynome intends to make
the fun stuff more fun to create and combine. It's a nicely designed,
yet empty, studio awaiting your applications and creativity.


Further Information
-------------------

For further information explore the documents within the docs directory.
