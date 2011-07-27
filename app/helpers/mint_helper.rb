module MintHelper

  # for an given element methods ascends the tree to deactivate parents as long as there are no active childs anoymore
  def deactivate_layout_on_task_deactivate(taskname)
    t = $tuplespace.take [:layout,nil,nil,nil,taskname,nil,nil],0
    t[2]='inactive'
    $tuplespace.write t
    p "deactivated #{t.inspect}"
    # look for other active childs 
    begin
      $tuplespace.read [:layout,nil,"active",t[3],nil,nil,nil],0
      return
    rescue Rinda::RequestExpiredError
      deactivate_layout_on_task_deactivate t[3]
    end
  end

  # helper method for finding correct parent container that needs to be recalculated on task deactivation
  # takes benefit of active information: if teh last task of a container is deactivated, walks up to the nearest active parental container
  def find_container_to_recalculate(taskname)
    c = $tuplespace.read([:layout, nil, nil,nil, taskname,nil,nil],0)
    if c[2].eql?("inactive")
      find_container_to_recalculate(c[3])
    else
      p "Container to recalculate #{c.inspect}"
      return c[4]
    end
  end


  def generate_layout_class(c,cl=nil)
    if (c.is_in? :displayed)
      state = " displayed"
    elsif (c.is_in? :hidden)
      state = " hidden"
    else
      state = " highlighted"
    end

    if (c.is_in? :marked)
       state <<  " marked"
    end
    return "id = '#{c.name}' style=' left: #{c.x}px; top: #{c.y}px; width:#{c.width}px; height:#{c.height}px;' class=' #{state} #{cl} cic'"
  end

  def generate_state_class(c)
    if (c.is_in? :marked)
          "marked"
    elsif (c.is_in? :displayed)
      "displayed"
    elsif (c.is_in? :hidden)
      "hidden"
    else
      "highlighted"
    end
  end

  def generate_layout_class2(c,cl=nil)
    if (c.is_in? :displayed)
      state = "displayed"
    elsif (c.is_in? :hidden)
      state = "hidden"
    else
      state = "highlighted"
    end
    return "id = '#{c.name}' class='#{state} #{cl}'"
  end

end
