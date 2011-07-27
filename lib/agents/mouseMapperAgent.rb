require 'rubygems'
require "bundler/setup"
require "MINT-core"

include MINT

class MouseMapperAgent < Agent
end

mouseAgent = MouseMapperAgent.new

#mapping_internal_render = ExecuteOnStateChange.new(Layoutelement,"calculated",cui.method(:render_cui),cui.method(:render_cui))
#cui.addMapping(mapping_internal_render)

click_select_mapping = Sequential.new(HWButton,"pressed",HWButton,"released",nil,0, 300, {{ Selectable  =>"highlighted"} =>:select})
mouseAgent.addMapping(click_select_mapping)

#drag_mapping = Sequential.new(HWButton,"pressed",Pointer,"moving",{HWButton=>"pressed"},310,1000,{{AIINChoose =>"focused"}=>:drag,
drag_mapping = Sequential.new(HWButton,"pressed",Pointer,"moving",nil,50,1500,{{AIINChoose =>["focused"]}=>:drag})
mouseAgent.addMapping(drag_mapping)

drop_mapping= ComplementarySendEvents.new(HWButton,"released",{ AIINChoose  =>"dragging"},{{ARContainer =>["listing"]} =>:drop,
                                                                                           {AIINChoose =>["dragging"]} =>:drop})
mouseAgent.addMapping(drop_mapping)

#drop_mapping = Sequential.new(HWButton,"released",AIINChoose,"dragging",nil,0,0,{{ARContainer =>["listing"]} =>:drop})
#mouseAgent.addMapping(drop_mapping)


mouseAgent.run
