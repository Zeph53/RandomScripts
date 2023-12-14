#!/bin/bash

#
## A script to shuffle the current active window's audio output via pulseaudio.

# Get the active process ID
ACTIVEPROCID=$(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5) _NET_WM_PID | cut -d ' ' -f 3)
# Get the active index ID
ACTIVEINDEXID=$(pacmd list-sink-inputs | awk -v pid="$ACTIVEPROCID" '/index:/{idx=$2} $1=="application.process.id" && $3=="\""pid"\""{print idx}')
# Get sink in use by active window
ACTIVESINKID=$(pacmd list-sink-inputs | awk -v active_idx="$ACTIVEINDEXID" '$1 == "index:" {idx = $2} $1 == "sink:" && idx == active_idx {printf "%s", $2}')
# Get available sink IDs
AVAILSINKIDS=$(pacmd list-cards | awk '/index:/{printf "%s ",$NF}')

#echo "Active Process ID: $ACTIVEPROCID"
#echo "Active Index ID: $ACTIVEINDEXID"
#echo "Active Sink ID: $ACTIVESINKID"
#echo "Available Sink IDs: $AVAILSINKIDS"

# Find the index of the current sink ID in the available sinks array
current_index=0
for sinkid in $AVAILSINKIDS; do
    if [ "$sinkid" == "$ACTIVESINKID" ]; then
        break
    fi
    ((current_index++))
done

# Get the next available sink ID that is not in use by the active window
while :; do
    ((current_index++))
    next_index=$((current_index % $(echo "$AVAILSINKIDS" | wc -w) + 1))
    NEXTSINKID=$(echo "$AVAILSINKIDS" | awk -v idx="$next_index" '{print $idx}')

    if [ "$NEXTSINKID" != "$ACTIVESINKID" ]; then
        break
    fi
done

# Change the active sink to the next available sink ID
pacmd move-sink-input $ACTIVEINDEXID $NEXTSINKID

# Done
