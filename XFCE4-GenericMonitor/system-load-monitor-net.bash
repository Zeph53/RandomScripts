#!/bin/bash

# Fixed filename for the temporary file to store network traffic readings
tempfile="$HOME/.cache/network_traffic.tmp"

# Interface name
interface="$(printf "$(ifconfig | grep RUNNING | grep -v lo | awk -F ":" '{print $1}')\n")"

# Create temporary file if it doesn't exist
touch "$tempfile"

# Read the last entry from the temporary file
read last_recv last_sent last_timestamp < "$tempfile" 2>/dev/null

# Get the current readings
current_recv=$(grep "$interface:" /proc/net/dev | awk '{print $2}')
current_sent=$(grep "$interface:" /proc/net/dev | awk '{print $10}')

# Update the temporary file with the current readings
echo "$current_recv $current_sent $(date '+%s')" > "$tempfile"

# Calculate the increase in traffic in Mbps
if [[ -n "$last_recv" && -n "$last_sent" ]]; then
    # Calculate the increase in received traffic in Mbps
    increase_recv=$(echo "scale=2; ($current_recv - $last_recv) * 8 / 1024 / 1024" | bc)
    # Calculate the increase in sent traffic in Mbps
    increase_sent=$(echo "scale=2; ($current_sent - $last_sent) * 8 / 1024 / 1024" | bc)
    printf "%07.3fMbps\n" "$increase_recv"
    printf "%07.3fMbps\n" "$increase_sent"
fi
