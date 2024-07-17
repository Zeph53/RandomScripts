#!/bin/bash

#
##
#
#
#
## Launch options
if
  [[ "$1" == "--help" ]] ||
  [[ "$1" == "-h" ]]
then
  printf "
Usage: 

$(basename "$0") [OPTION]

Switch the audio output sink associated with the current active 
window process to the next available audio output sink.

Options:
--next, -n        Switch to the next sink when an audio window becomes active.
--current, -c     Switch the audio output sink associated with the current process to the next available sink.
--help, -h        Display this help menu.




PulseAudio-ActiveWindowOutput-Shuffler
Copyright (C) 2024 GitHub.com/Zeph53
This program comes with ABSOLUTELY NO WARRANTY!
This is free software, and you are welcome to
redistribute it under certain conditions.
See \"https://www.gnu.org/licenses/gpl-3.0.txt\"
"
#
#
#
#
## 
active_pid="$(xprop -id $(xprop -root "_NET_ACTIVE_WINDOW" | cut -d ' ' -f 5) "_NET_WM_PID" | cut -d ' ' -f 3)"
printf "$active_pid\n"


##
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

