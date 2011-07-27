require 'rubygems'
require "bundler/setup"
require 'em-websocket'
require "juggernaut"
require 'eventmachine'
require "MINT-core"

include MINT

class MouseHTMLAgent < Agent

def create_data(cmd,identifier, x, y)
  {:cmd=>cmd,:touch=>{:identifier=>"touch-#{identifier}",:pageX=>x.to_i,:pageY=>y.to_i}}.to_json
end
  def initialize
    super
    @timer = nil
    Pointer3D.all.destroy
    Thread.new do
      EventMachine.run do
        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 5006) do |ws|
          ws.onopen    {

            puts "client connected"
            HWButton.all.destroy
            @mouse = Pointer3D.first_or_create(:name => 'pointer')
            @mouse.process_event("connect")
            @left_button = HWButton.first_or_create(:name => 'left_button')
            @right_button = HWButton.first_or_create(:name => 'right_button')
            @middle_button = HWButton.first_or_create(:name => 'middle_button')
            @left_button.process_event("connect")
            @right_button.process_event("connect")
            @middle_button.process_event("connect")
            @wheel   = Wheel.first_or_create(:name => 'wheel')
            @mousemode = MouseMode.first_or_create(:name => 'mousemode')

            @mouse.cache_coordinates(nil,nil,0) if not @mouse.z or @mouse.z<0

          }

          ws.onmessage do |msg|
            puts msg
            case msg
              when /LEFT_PRESSED/

                @left_button.process_event("press")
              when /MIDDLE_PRESSED/
                @middle_button.process_event("press")
              when /RIGHT_PRESSED/
                @right_button.process_event("press")
              when /LEFT_RELEASED/
                @left_button.process_event("release")
              when /MIDDLE_RELEASED/
                @middle_button.process_event("release")
              when /RIGHT_RELEASED/
                @right_button.process_event("release")
              when /WHEEL_UP/
                update_z_position(1)
              when /WHEEL_DOWN/
                update_z_position(-1)
              when /NEW-TOUCH/
                a= msg.split('/')
                Juggernaut.publish("thumb", create_data("NEW",a[1],a[2],a[3]))
              when /REMOVE-TOUCH/
                a= msg.split('/')
                Juggernaut.publish("thumb", create_data("DEL",a[1],a[2],a[3]))
              when /MOVE-TOUCH/
                a= msg.split('/')
                Juggernaut.publish("thumb", create_data("POS",a[1],a[2],a[3]))
              when /CROSSED/
                EventMachine.defer(method(:border_crossed))
              when /TAG/
                EventMachine.defer(method(:tag_detected))
              when /\d,\d/
                a= msg.split(',')
                update_mouse_position(Integer(a[0]),Integer(a[1]))
              else
                puts "not supported command>#{msg}<"
            end
          end
          ws.onclose   {
            puts "WebSocket closed"
            @mouse.process_event("disconnect")
          }
        end
      end
    end
  end                        #    @mouse = Pointer3D.first_or_create(:name => 'pointer')
  # @mouse.x=x
  # @mouse.y=y

  def border_crossed
    p "Border crossed"

    ar_frame = AIO.first(:name=>"ar_frame")
    p ar_frame.process_event("suspend")

    aio = AIO.first(:name=>"0")
    p aio.process_event("present")

  end

  def tag_detected
    p "tag detected"

    tag = AIO.first(:name=>"tag")
    p tag.process_event("suspend")

    ar_frame = AIO.first(:name=>"ar_frame")
    p ar_frame.process_event("suspend")

    aio = AIO.first(:name=>"0")
    p aio.process_event("present")


    #n,x,y,z,width,height = /TAG-(\d+),(\d+),(\d+),(\d+),(\d+)/.match(msg).to_a.map &:to_i
    #p "X:#{x},Y:#{y},Witdh:#{width},HEight#{height}"
  end


  def update_z_position(delta)
    z = @mouse.cached_z + (delta*50)
    return if (delta == -1 and z < 0)
    return if (delta == 1 and z > 1000)

    @mouse.cache_coordinates(nil,nil,z)

    Juggernaut.publish("pointer", "POS-#{@mouse.cached_x},#{@mouse.cached_y},#{@mouse.cached_z}")
    @mouse.process_event("move")
  end

  def update_mouse_position(x,y)
    Juggernaut.publish("pointer", "POS-#{x},#{y},100")
    #@mouse = Pointer3D.first_or_create(:name => 'pointer')
    @mouse.cache_coordinates(x,y)
    @mouse.process_event("move")
  end

  def publish_drag(result)
    @mouse= Pointer3D.first
    p "Publish DRAG #{result.name}"
    Juggernaut.publish("pointer", "DRAG-#{result.name}-#{@mouse.x},#{@mouse.y},100")
  end

  def publish_drop(result)
    @mouse= Pointer3D.first
    p "Publish DROP #{result.name}"
    Juggernaut.publish("pointer", "DROP-#{result.name}-#{@mouse.x},#{@mouse.y},100")
  end

end

mouseAgent = MouseHTMLAgent.new


publish_drag= ExecuteOnStateChange.new(AIINChoose,["dragging"],mouseAgent.method(:publish_drag))
mouseAgent.addMapping(publish_drag)


publish_drop= ExecuteOnStateChange.new(AIINChoose,["dropped"],mouseAgent.method(:publish_drop))
mouseAgent.addMapping(publish_drop)

#mapping_internal_render = ExecuteOnStateChange.new(Layoutelement,"calculated",cui.method(:render_cui),cui.method(:render_cui))
#cui.addMapping(mapping_internal_render)

#click_select_mapping = Sequential.new(HWButton,:pressed,HWButton,:released, 300, { AIINChoose  =>"focused"},:choose)
#mouseAgent.addMapping(click_select_mapping)

mouseAgent.run
