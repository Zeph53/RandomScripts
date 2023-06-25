#!/bin/bash

#
## 

#pacmd set-default-(sink|source) NAME|#N

#pacmd move-(sink-input|source-output) #N SINK|SOURCE

export AVAILSINKIDS="$( printf "$( pacmd list-cards | grep index | sed 's/.*: //g' | sed -z 's/\n/ /g' )")" 

pacmd set-default-sink $(printf $AVAILSINKIDS)

