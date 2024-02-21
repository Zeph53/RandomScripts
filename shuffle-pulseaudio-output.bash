#!/bin/bash

# Get the active process ID
ACTIVE_WINDOW_ID=$(xprop -root "_NET_ACTIVE_WINDOW" | awk '/_NET_ACTIVE_WINDOW/ {print $NF}')
ACTIVE_PID=$(xprop -id "$ACTIVE_WINDOW_ID" "_NET_WM_PID" | awk '/_NET_WM_PID/ {print $NF}')

# Get the active index ID
active_index_id=$(pacmd list-sink-inputs | awk -v pid="$ACTIVE_PID" '
    $1 == "index:" { idx = $2; app_id = 0 }
    $1 == "application.process.id" && $3 == "\""pid"\"" {
        print idx
        exit
    }
')

# Get the active sink ID
ACTIVE_SINK_ID=$(pacmd list-sink-inputs | awk -v active_idx="$active_index_id" '$1 == "index:" && $2 == active_idx {getline; print $NF}')

# Get the available sink IDs
AVAILABLE_SINKS=$(pacmd list-sinks | awk '/index:/{print $NF}')

# Switch the current process to the next available sink
if [ -n "$ACTIVE_SINK_ID" ]; then
    avail_sink_ids=$AVAILABLE_SINKS
    num_sinks=$(echo "$avail_sink_ids" | wc -w)

    current_index=0
    for sink_id in $avail_sink_ids; do
        if [ "$sink_id" == "$ACTIVE_SINK_ID" ]; then
            break
        fi
        ((current_index++))
    done

    ((current_index++))
    next_index=$((current_index % num_sinks + 1))
    next_sink_id=$(echo "$avail_sink_ids" | awk -v idx="$next_index" '{print $idx}')

    if [ "$next_sink_id" != "$ACTIVE_SINK_ID" ]; then
        pacmd move-sink-input "$active_index_id" "$next_sink_id"
        echo "Audio output for the active window switched to the next available sink."
        exit 0
    fi
fi

echo "Invalid usage. Use '--help' for more information."
exit 1
