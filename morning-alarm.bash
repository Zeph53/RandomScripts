#!/bin/bash

#
## 

pkill quodlibet ;\
sleep 3 ;\
pactl set-sink-volume @DEFAULT_SINK@ 32768 ;\
quodlibet \
  --run \
  --volume 100 \
  --repeat 1 \
  --repeat-type current \
  --start-playing \
  --play \
  --add-location "/media/Multimedia-Z/Hassium.ogg" \
  --play-file "/media/Multimedia-Z/Hassium.ogg" \
  --enqueue "/media/Multimedia-Z/Hassium.ogg" 
