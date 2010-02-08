module Polynome
  # The representation of an application. An application is a representation of an external app which is communicated to via OSC messages.
  # Each application has a given type - which maps onto one of the available monome models (64, 128, 256).
  # Each application also has a unique name which is used to identify it.
  #
  # Applications communicate with Polynome through a frame buffer onto which it pushes frames to be displayed.


  class Application
    include Loggable
    attr_reader   :name, :model, :device, :listener, :sender, :inport, :outport, :host, :client_host
    attr_accessor :frame_buffer

    def initialize(params = {})
      params.reverse_merge! :debug => Defaults.debug?

      unless params[:device] then
        raise ArgumentError,
        "Polynome::Application#initialize requires a "\
        "device to be specified",
        caller
      end

      unless params[:name] then
        raise ArgumentError,
        "Polynome::Application#initialize requires a "\
        "name to be specified",
        caller
      end

      @prefix        = OSCPrefix.new('/polynome/application')
      @debug         = params[:debug]
      @logger        = params[:logger] || Defaults.logger
      @inport        = params[:inport]
      @outport       = params[:outport]
      @host          = params[:host]
      @client_host   = params[:client_host]
      @client_prefix = params[:client_prefix]
      @device        = params[:device]
      @name          = params[:name].to_s
      @model         = Model.get_model(params[:device])
      @bank          = LightBank.new(@model.width, @model.height)
      @logger_name   = "#{params[:name].to_s}-App"
      @logger_char   = 'A'
      @comms         = @inport && @host && @outport && @client_host

      if @comms
        log "Setting up comms"
        @listener = OSCListener.new(inport, :host => @host, :owner => @name, :prefix => @prefix)
        @listener.add_method('action/light/on',     'ii') {|mesg| receive_light_on(mesg)}
        @listener.add_method('action/light/off',    'ii') {|mesg| receive_light_off(mesg)}
        @listener.add_method('action/light/toggle', 'ii') {|mesg| receive_light_toggle(mesg)}
        @listener.start
        @sender   = OSCSender.new(outport, :host => @client_host, :owner => @name, :prefix => @client_prefix)
        @sender.send('registration/successful', inport, @prefix)
      end

      log "READY", "Application ready"
    end

    def receive_light_on(mesg)
      x,y = *mesg.args

      on(x,y)
      refresh
    end

    def receive_light_off(mesg)
      x,y = *mesg.args

      off(x,y)
      refresh
    end

    def receive_light_toggle(mesg)
      x,y = *mesg.args

      toggle(x,y)
      refresh
    end

    def init
    end

    def racked
    end

    def num_quadrants
      @model.num_quadrants
    end

    def orientation
      @model.orientation
    end

    def on(x,y)
      @bank.on(x,y)
    end

    def off(x,y)
      @bank.off(x,y)
    end

    def toggle(x,y)
      @bank.toggle(x,y)
    end

    def refresh
      update_display(@bank.to_frame)
    end

    def receive_button_event(action, x, y, log=false)
      if log
        puts "[APPLICATION] receiving #{action} x:#{x}, y:#{y}"
        puts ""
        puts "---"
        puts ""
      end

      case action
      when :keydown then button_pressed(x,y)
      when :keyup   then button_released(x,y)
      else raise "Unknown button event: #{action}"
      end
    end

    def button_pressed(x,y)
      @sender.send('action/button/pressed', x, y)
    end

    def button_released(x,y)
      @sender.send('action/button/released', x, y)
    end

    def update_display(*frames)
      if frames.size != num_quadrants then
        raise ArgumentError,
        "Incorrect number of frames sent for update. "\
        "Expected #{num_quadrants}, got #{frames.size}.",
        caller
      end

      frames = frames.map{|frame| frame.clone}
      frame_update = FrameUpdate.new(self, frames)
      @frame_buffer.push(frame_update) if @frame_buffer
    end

    def inspect
      "Application, name: #{@name}, model: #{@model.name}".color(:yellow)
    end
  end
end


