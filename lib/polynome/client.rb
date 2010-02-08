module Polynome
  class Client
    include Loggable
    attr_reader :table_sender, :table_listener

    def initialize(params={})
      params.reverse_merge!(
                            :device  => 64,
                            :name    => 'foo',
                            :outport => Defaults.table_inport,
                            :inport  => 4080,
                            :host    => 'localhost',
                            :debug   => Defaults.debug?
                            )

      @debug       = params[:debug]
      @name        = "#{params[:name].to_s}-Client"
      @logger      = params[:logger] || Defaults.logger
      @device      = params[:device].to_s
      @inport      = params[:inport]
      @host        = params[:host]
      @logger_char = 'C'

      #TODO perhaps need to sanitize name?
      @prefix   = OSCPrefix.new("/polynome/client/#{params[:name]}")
      @listener = OSCListener.new(params[:inport], :prefix => @prefix, :owner => "#{@name}")
      @table_sender   = OSCSender.new(params[:outport],  :owner  => "#{@name}(table)", :prefix => '/polynome/table')

      @listener.add_method("registration/successful", 'is') {|mesg| _client_receive_registration_successful(mesg)}
      @listener.add_method("registration/failed",     's')  {|mesg| _client_receive_registration_failed(mesg)}
      @listener.add_method("action/button/pressed", 'ii')   {|mesg| _client_receive_button_pressed(mesg)}
      @listener.add_method("action/button/released", 'ii')  {|mesg| _client_receive_button_released(mesg)}
      @listener.start

      log 'Sending registration details'
      @table_sender.send('register/', @name, @device, @inport, @host, @prefix)

      while !@registered
        sleep 0.1
      end

      #callback hook
      log "INIT", "Initialising Application"
      init

      log "READY", "Finished initializing"
    end

    def inspect
      "Client::App, device: #{@device}, host: #{@host}, inport: #{@inport}, name: #{@name}"
    end

    def light_on(x,y)
      @app_sender.send('action/light/on', x, y)
    end

    def light_off(x,y)
      @app_sender.send('action/light/off', x, y)
    end

    def toggle(x,y)
      @app_sender.send('action/light/toggle', x, y)
    end

    def button_pressed(x,y)
    end

    def button_released(x,y)
    end

    private
    def _client_receive_registration_successful(mesg)
      port, prefix = *mesg.args

      log "Registration successful. Setting up a connection with App.."
      @app_sender = OSCSender.new(port, :prefix => prefix, :owner => "#{@name}(app)")
      @registered = true
    end

    def _client_receive_registration_failed(mesg)
      error_message = *mesg.args
      log "ERROR", "Unable to register with the Table. Error receieved was: #{error_message}"
      log "ERROR", "Exiting"
      raise "Exiting"
    end

    def _client_receive_button_pressed(mesg)
      x,y = *mesg.args
      button_pressed(x,y)
      log "PRESS", "Button pressed: #{x}, #{y}"
    end

    def _client_receive_button_released(mesg)
      x,y = *mesg.args
      button_released(x,y)
      log "RELEASE", "Button released: #{x}, #{y}"
    end
  end
end


