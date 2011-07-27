#!/bin/bash

gnome-terminal --tab -t "Redis" -e "../../redis-2.2.4/src/redis-server" --tab -t "Juggernaut" -e "./script/mint/juggernaut.sh" --tab -t "Tuplespace" -e "bundle exec mint-tuplespace" --tab -t "MoBe2011-AUI" -e "./script/mint/aui.sh" --tab -t "CUI" -e "bundle exec mint-cui-gfx" --tab -t "Webserver" -e "./script/mint/webserver.sh" --tab -t "Mouse" -e "./script/mint/mouse.sh" --tab -t "Mapper" -e "./script/mint/mouseMapper.sh" --tab -t "gesture" -e "./script/mint/gesture.sh" --tab -t "FUI" -e "./script/mint/fui.sh"


