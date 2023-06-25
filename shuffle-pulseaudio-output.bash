#!/bin/bash

#
## A script to shuffle the current active window's audio output via pulseaudio.

export ACTIVEPROCID="$( xprop -id $( xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | awk "{print \$2}" )| grep "NET_WM_PID" | sed 's/ //g' | sed 's/.*=//g' )"

#WINID=$(xprop -root | awk '/_NET_ACTIVE_WINDOW/ && /0x/ {print $5}' | cut -d'x' -f2)
#while [ $(wmctrl -l | grep $WINID | awk '{print $4}') != $FOCUS ]; do
#        echo $WINID
#    done


export ACTIVEINDEXID="$(printf "$( pacmd list-sink-inputs | grep -B 26 "$ACTIVEPROCID" | sed -z 's/\n//g' | sed -z 's/\t//g' | sed 's/ //g' | sed 's/index:\.*//g' | sed 's/\driver.*//g' )")"

export AVAILSINKIDS="$( printf "$( pacmd list-cards | grep index | sed 's/.*: //g' | sed -z 's/\n/ /g' )")"

echo $ACTIVEPROCID
echo $ACTIVEINDEXID
echo $AVAILSINKIDS
#pactl move-sink-input $ACTIVEINDEXID $AVAILSINKIDS


#for "0" in "$ACTIVEINDEXID" ; do
    
#done
