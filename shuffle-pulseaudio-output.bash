#!/bin/bash

# Function to get the active process ID
get_active_pid() {
    xprop -id $(xprop -root "_NET_ACTIVE_WINDOW" | cut -d ' ' -f 5) "_NET_WM_PID" | cut -d ' ' -f 3
}

# Function to get the active index ID
get_active_index() {
    local pid="$1"
    pacmd list-sink-inputs | awk -v pid="$pid" '
        $1 == "index:" { idx = $2; app_id = 0 }
        $1 == "application.process.id" && $3 == "\""pid"\"" {
            print idx
            exit
        }
    '
}

# Function to get the active sink ID
get_active_sink() {
    local active_index="$1"
    pacmd list-sink-inputs | awk -v active_idx="$active_index" '$1 == "index:" {idx = $2} $1 == "sink:" && idx == active_idx {printf "%s", $2}'
}

# Function to get the available sink IDs
get_available_sinks() {
    pacmd list-sinks | awk '/index:/{printf "%s ",$NF}'
}

# Function to switch the current process to the next available sink
switch_current_to_next_sink() {
    active_proc_id=$(get_active_pid)
    active_index_id=$(get_active_index "$active_proc_id")
    active_sink_id=$(get_active_sink "$active_index_id")

    if [ -n "$active_sink_id" ]; then
        avail_sink_ids=$(get_available_sinks)
        num_sinks=$(echo "$avail_sink_ids" | wc -w)

        current_index=0
        for sink_id in $avail_sink_ids; do
            if [ "$sink_id" == "$active_sink_id" ]; then
                break
            fi
            ((current_index++))
        done

        ((current_index++))
        next_index=$((current_index % num_sinks + 1))
        next_sink_id=$(echo "$avail_sink_ids" | awk -v idx="$next_index" '{print $idx}')

        if [ "$next_sink_id" != "$active_sink_id" ]; then
            pacmd move-sink-input "$active_index_id" "$next_sink_id"
            echo "Audio output for the active window switched to the next available sink."
            exit 0
        fi
    fi
}

# Function to monitor active window changes and switch to the next sink when an audio window becomes active
monitor_window_and_switch_to_next_sink() {
    # Get the PID of the terminal
    terminal_pid=$(get_active_pid)

    # Flag to track whether audio has been detected
    audio_detected=false
    # Flag to track whether the prompt has been displayed
    prompt_displayed=false
    last_active_window_pid=""

    # Wait until a window with audio becomes active while the terminal is the only active window
    while :; do
        active_window_pid=$(get_active_pid)
        if [ "$active_window_pid" != "$terminal_pid" ]; then
            # Terminal is not the only active window
            sleep 0.1
            terminal_pid=$(get_active_pid)
            continue
        fi

        active_index_id=$(get_active_index "$active_window_pid")
        active_sink_id=$(get_active_sink "$active_index_id")

        if [ "$last_active_window_pid" != "$active_window_pid" ]; then
            last_active_window_pid="$active_window_pid"
            if [ -z "$active_sink_id" ]; then
                if ! $prompt_displayed; then
                    echo "Please select a window with audio."
                    prompt_displayed=true
                fi
                echo "The selected window has no audio."
                if [ "$1" == "--current" ]; then
                    echo "Error: No audio detected in the selected window."
                    exit 1
                fi
                audio_detected=false  # Reset the flag when there's no audio
            else
                if ! $audio_detected; then
                    audio_detected=true  # Set the flag only once when audio is detected
                    switch_current_to_next_sink
                fi
                prompt_displayed=false  # Reset the flag when audio is detected
            fi
        fi

        sleep 0.1
    done
}

# Function to display help
show_help() {
    echo "Usage: $(basename "$0") [OPTION]"
    echo "Switch the audio output sink associated with the current process to the next available audio output sink."
    echo ""
    echo "Options:"
    echo "  --next, -n        Monitor active window changes and switch to the next sink when an audio window becomes active."
    echo "  --current, -c     Switch the audio output sink associated with the current process to the next available sink."
    echo "  --help, -h        Display this help menu."
}

# Parse command-line options
while getopts ":cnh-:" opt; do
    case "$opt" in
        c|--current)
            monitor_window_and_switch_to_next_sink "--current"
            ;;
        n|--next)
            monitor_window_and_switch_to_next_sink "--next"
            ;;
        h|--help)
            show_help "--help"
            ;;
        -)
            # Handle long options
            case "${OPTARG}" in
                current)
                    monitor_window_and_switch_to_next_sink "--current"
                    ;;
                next)
                    monitor_window_and_switch_to_next_sink "--next"
                    ;;
                help)
                    show_help
                    ;;
                *)
                    echo "Invalid option: --$OPTARG" >&2
                    exit 1
                    ;;
            esac
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

echo "Invalid usage. Use '--help' for more information."
exit 1
