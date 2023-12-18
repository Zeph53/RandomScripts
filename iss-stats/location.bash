#!/bin/bash

# Get the current time in the local timezone
current_time=$(TZ="$(date +%Z)" date -u +"%Y-%m-%dT%H:%M:%S")

# Fetch the ISS data and process to find the next closest maneuver
next_maneuver=$(curl -s https://nasa-public-data.s3.amazonaws.com/iss-coords/current/ISS_OEM/ISS.OEM_J2K_EPH.txt \
| grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}' \
| awk -v current="$current_time" '$1 > current' \
| head -n 1)

# Display the closest upcoming maneuver and the expected system time
echo "Next maneuver:"
echo "$next_maneuver" | awk -F ' ' '{print $1; for(i=2;i<=NF;i++) printf "%4s%s\n", "", $i}'

if [ -n "$next_maneuver" ]; then
    next_maneuver_time=$(echo "$next_maneuver" | awk '{print $1}')
    system_time_message="The system time at the maneuver:"
    formatted_system_time=$(date -u -d "$next_maneuver_time" +'%Y-%m-%d %H:%M:%S %Z')
    user_timezone=$(date +"%Z")
    local_time=$(TZ=":$user_timezone" date -d "$next_maneuver_time UTC" +'%Y-%m-%d %I:%M:%S %p %Z')
    echo "$system_time_message $formatted_system_time."
    echo "Your userspace time will be: $local_time."
fi
