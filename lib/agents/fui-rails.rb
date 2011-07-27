#require File.dirname(__FILE__) + '/../../config/boot'
#require 'commands/runner'

require 'rubygems'
require "bundler/setup"
#require "#{RAILS_ROOT}/app/overrides/object"
#require "monitor"
require "juggernaut"
require "MINT-core"
include MINT

class CUIAgent < Agent
  
  #def render_cui(result)
  #  p  "CUI agent received render request #{result.inspect} "
  #
  #  cio = nil
  #  while not cio do
  #    cio = CIO.first(:name =>result.name)
  #    sleep 0.1 if not cio
  #  end
  #
  #  p  "CIO retrieved #{cio.inspect} for #{result.name}"
  #  forward_to_rails(result,cio,false)
  #end
  #
  #def forward_to_rails(result,cio,remove)
  #  data = nil
  #  @monitor.synchronize do
  #    fui = nil
  #    if not remove
  #      puts cio.class.name
  #      fui = request(:controller => :mint, :action=> cio.class.name.split('::').last ,:id=>result.name, :layout=>nil)
  #    end
  #    data = @av.render(:update) do |page|
  #      if remove
  #        page["##{result.name}"].remove()
  #      else
  #        page["#main"].prepend fui
  #      end
  #    end
  #  end
  #  Juggernaut.publish("channel_name", data)
  # # Juggernaut.send_to_all(data)
  #  #p  "sent  ajax request #{data} "
  #end

  def highlight(result)
    #@monitor.synchronize do
    #  data = @av.render(:update ) do |page|
    #      page["div##{result.name}"].addClass('highlighted').removeClass('displayed')
    #    end
    #  Juggernaut.publish("channel_name", data)
    #  "$('#slide1_images').css('left',parseInt($('#slide1_images').css('left'))-1198+'px');"
    #end
    #
   #
       Juggernaut.publish("channel_name", "$('div##{result.name}').addClass('highlighted').removeClass('displayed');")
  end

  def unhighlight(result)
    #@monitor.synchronize do
    #  data = @av.render(:update) do |page|
    #    page["div##{result.name}"].removeClass('highlighted')
    #    page["div##{result.name}"].removeClass('hidden')
    #    page["div##{result.name}"].addClass('displayed')
    #  end
    #  Juggernaut.publish("channel_name", data) #"div##{result.name}.addClass('displayed'")
    #end
    ##
    Juggernaut.publish("channel_name", "$('div##{result.name}').addClass('displayed');$('div##{result.name}').removeClass('highlighted');$('div##{result.name}').removeClass('hidden');")


  end

  def hide_cui(result)
    puts "HIDE #{result.name}"

    #@monitor.synchronize do
    #      data = @av.render(:update) do |page|
    #        page["div##{result.name}"].removeClass('highlighted')
    #            page["div##{result.name}"].removeClass('displayed')
    #            page["div##{result.name}"].addClass('hidden')
    #
    ##        page["div##{result.name}"].hide()
    #      end
    #      Juggernaut.publish("channel_name", data) #"div##{result.name}.addClass('displayed'")
    #    end
    Juggernaut.publish("channel_name", "$('div##{result.name}').addClass('hidden');$('div##{result.name}').removeClass('highlighted');$('div##{result.name}').removeClass('displayed');")

    end


  def select_cui(result)
    puts "select #{result.name}"
    # @monitor.synchronize do
    #  data = @av.render(:update) do |page|
    #      page["input[id='#{result.name}']"].attr('checked', 'true')
    #    end
    #  Juggernaut.publish("channel_name", data) #"div##{result.name}.addClass('displayed'")
    #end
    Juggernaut.publish("channel_name", "$('input##{result.name}').attr('checked','true');")

  end

  def mark(result)
    puts "mark #{result.name}"
     #@monitor.synchronize do
     # data = @av.render(:update) do |page|
     #     page["div[id='#{result.name}']"].addClass('marked')
     #   end
     # Juggernaut.publish("channel_name", data) #"div##{result.name}.addClass('displayed'")
     #end
    Juggernaut.publish("channel_name", "$('div##{result.name}').addClass('marked');")

  end

  def unmark(result)
    #puts "unmark #{result.name}"
    # @monitor.synchronize do
    #  data = @av.render(:update) do |page|
    #      page["div[id='#{result.name}']"].removeClass("marked")
    #    end
    #  Juggernaut.publish("channel_name", data) #"div##{result.name}.addClass('displayed'")
    #end
    Juggernaut.publish("channel_name", "$('div##{result.name}').removeClass('marked');")

  end


  def deselect_cui(result)
    puts "deselect #{result.name}"
     #@monitor.synchronize do
     # data = @av.render(:update) do |page|
     #   page["input[id='#{result.name}']"].removeAttr('checked')
     #   end
     # Juggernaut.publish("channel_name", data) #"div##{result.name}.addClass('displayed'")
     #end
    Juggernaut.publish("channel_name", "$('input##{result.name}').removeAttr('checked');")

  end

  def remove_cui(result)
    p  "CUI removal detected #{result.inspect} "   
    forward_to_rails(result,nil,true)
  end
  
   def focus_cui(result)
     p  "CUI #{result.abstract_states} detected #{result.inspect} "
#     remove_cui(result)
#     render_cui(result)
    highlight(result)
  end
  
  def defocus_cui(result)
    p  "CUI #{result.abstract_states} detected #{result.inspect} "
    #remove_cui(result)
    #render_cui(result)
    unhighlight(result)
  end
  
  def pointer_move(result)
    if (result == nil)
      puts "ERROR - result of mouse move tracking  = nil!"
      return 
    end
#    Juggernaut.publish("channel_name", "pointerDraw(#{result.x},#{result.y},'#00ff00')")
  end

  def pointer_dragging(result)
    if (result == nil)
      puts "ERROR - result of mouse move tracking  = nil!"
      return
    end
    Juggernaut.publish("channel_name", "drawPointer('#0000ff')")
  end


  def pointer_stopped(result)
    if (result == nil)
      puts "ERROR - result of mouse stopped tracking  = nil!"
      return 
    end
    Juggernaut.publish("channel_name", "drawPointer('#ff0000')")
  end

  def next_page(result)
      if (result == nil)
        puts "ERROR - result of mouse stopped tracking  = nil!"
        return
      end
      Juggernaut.publish("channel_name", "$('#slide1_images').css('left',parseInt($('#slide1_images').css('left'))+1198+'px');")
    end

  def prev_page(result)
        if (result == nil)
          puts "ERROR - result of mouse stopped tracking  = nil!"
          return
        end
        Juggernaut.publish("channel_name", "$('#slide1_images').css('left',parseInt($('#slide1_images').css('left'))-1198+'px');")
      end


  #def initialize()
  #  @monitor = Monitor.new
  #    @av = ActionView::Base.new(Rails::Configuration.new.view_path)
  #  super()
  #end
end

cui = CUIAgent.new

#mapping_internal_render = ExecuteOnStateChange.new(CIO,"positioned",cui.method(:render_cui),cui.method(:render_cui))
#cui.addMapping(mapping_internal_render)
#
mapping_internal_focus = ExecuteOnStateChange.new(CIO,"highlighted",cui.method(:focus_cui),cui.method(:focus_cui))
cui.addMapping(mapping_internal_focus)
#
mapping_internal_defocus = ExecuteOnStateChange.new(CIO,"displayed",cui.method(:defocus_cui))
cui.addMapping(mapping_internal_defocus)

mapping_internal_hide = ExecuteOnStateChange.new(CIO,"hidden",cui.method(:hide_cui))
cui.addMapping(mapping_internal_hide)

mapping_internal_select = ExecuteOnStateChange.new(AIINChoose,"chosen",cui.method(:select_cui))
cui.addMapping(mapping_internal_select)

mapping_internal_deselect = ExecuteOnStateChange.new(AIINChoose,"listed",cui.method(:deselect_cui))
cui.addMapping(mapping_internal_deselect)

#mapping_internal_pointer_move = ExecuteOnStateChange.new(Pointer,[:moving],cui.method(:pointer_move))
#cui.addMapping(mapping_internal_pointer_move)

mapping_internal_bg_fade = ExecuteOnStateChange.new(MarkableRadioButton,[:marked],cui.method(:mark))
cui.addMapping(mapping_internal_bg_fade)

mapping_internal_bg_fade_back = ExecuteOnStateChange.new(MarkableRadioButton,[:unmarked],cui.method(:unmark))
cui.addMapping(mapping_internal_bg_fade_back)



#mapping_internal_pointer_dragging = ExecuteOnStateChange.new(Pointer,[:moving],cui.method(:pointer_dragging))
#cui.addMapping(mapping_internal_pointer_dragging)

mapping_internal_pointer_stopped = ExecuteOnStateChange.new(Pointer,[:stopped],cui.method(:pointer_stopped))
cui.addMapping(mapping_internal_pointer_stopped)

mapping_internal_head_next= ExecuteOnStateChange.new(Head,[:moving_right],cui.method(:next_page))
cui.addMapping(mapping_internal_head_next)

mapping_internal_head_prev= ExecuteOnStateChange.new(Head,[:moving_left],cui.method(:prev_page))
cui.addMapping(mapping_internal_head_prev)

cui.run
