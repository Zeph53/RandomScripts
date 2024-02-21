#!/bin/bash

#
## A simple script to set CPU speed 
#
## Environment variables.
CPUMIN="/sys/devices/system/cpu/cpufreq/policy*/cpuinfo_min_freq"
CPUMAX="/sys/devices/system/cpu/cpufreq/policy*/cpuinfo_max_freq"
CSCALEMIN="/sys/devices/system/cpu/cpufreq/policy*/scaling_min_freq"
CSCALEMAX="/sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq"
GOVERN="/sys/devices/system/cpu/cpufreq/policy*/scaling_available_governors"
CURGOV="/sys/devices/system/cpu/cpufreq/policy*/scaling_governor"


if [ $# -eq 1 ] && { [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "-?" ] || [ "$1" = "--?" ]; }; then
    # Display usage instructions
    printf "Usage: cpu-speed.bash <min_speed> <max_speed> <governor_mode>\n"
    printf "Run the script without any arguments to use interactive mode.\n"
    exit 0
fi


if [ $# -eq 3 ]; then
    ARGMIN=$1
    ARGMAX=$2
    GOVSEL=$3
    # Get available governor modes
    AVAILABLE_GOVERNORS=($(cat $GOVERN | sort -u))
    # Check if provided governor mode exists
    if [[ " ${AVAILABLE_GOVERNORS[*]} " =~ " $GOVSEL " ]]; then
        # Set CPU speeds
        printf "$ARGMIN" | sed 's/$/000/g' | tee $CSCALEMIN >/dev/null
        printf "$ARGMAX" | sed 's/$/000/g' | tee $CSCALEMAX >/dev/null
        # Set CPU governor mode
        printf "$GOVSEL" | sed 's/default/schedutil/g' | tee $CURGOV >/dev/null
        # Display updated settings
        printf "Set CPU speed to $(cat $CSCALEMIN | sort -u | sed 's/...$//g')MHz - $(cat $CSCALEMAX | sort -u | sed 's/...$//g')MHz\n"
        printf "CPU governor mode set to $GOVSEL\n"
    else
        # If governor mode doesn't exist, display an error message
        printf "Error: '$GOVSEL' is not a valid governor mode. Available modes: ${AVAILABLE_GOVERNORS[*]}\n"
    fi
else


#
## READ for user input with a prompt.
  read -e -p "$(\
    printf "Set the minimum CPU frequency in MHz ($(\
#
## Display the minimum operating speed of the sum of all CPU cores.
      cat $CPUMIN |\
        awk '{for(i=1;i<=NF;i++){sum+=$i;num++}}END{print(sum/num)}' |\
        sed 's/...$//g')-$(\
#
## Display the maximum operating speed of the sum of all CPU cores.
      cat $CPUMAX |\
        awk '{for(i=1;i<=NF;i++){sum+=$i;num++}}END{print(sum/num)}' |\
        sed 's/...$//g' )) - Currently \"$(\
#
## Display the minimum CPU operating speed scaling factor.
      cat $CSCALEMIN |\
        awk '{for(i=1;i<=NF;i++){sum+=$i;num++}}END{print(sum/num)}' |\
        sed 's/...$//g')\": ")"\
    SETMINSCALE
#
## Print the result of READ into each CPU's scaling factor for each available CPU.
  printf "$SETMINSCALE" |\
    sed 's/$/000/g' |\
    tee $CSCALEMIN >\
    /dev/null


#
## READ for user input with a prompt.
  read -e -p "$(\
    printf "Set the maximum CPU frequency in MHz ($(\
#
## Display the minimum operating speed of the sum of all CPU cores.
      cat $CPUMIN |\
        awk '{for(i=1;i<=NF;i++){sum+=$i;num++}}END{print(sum/num)}' |\
        sed 's/...$//g')-$(\
#
## Display the maximum operating speed of the sum of all CPU cores.
      cat $CPUMAX |\
        awk '{for(i=1;i<=NF;i++){sum+=$i;num++}}END{print(sum/num)}' |\
        sed 's/...$//g' )) - Currently \"$(\
#
## Display the maximum CPU operating speed scaling factor.
      cat $CSCALEMAX |\
        awk '{for(i=1;i<=NF;i++){sum+=$i;num++}}END{print(sum/num)}' |\
        sed 's/...$//g')\": ")"\
    SETMAXSCALE
#
## Print the result of READ into each CPU's scaling factor for each available CPU.
  printf "$SETMAXSCALE" |\
    sed 's/$/000/g' |\
    tee $CSCALEMAX >\
    /dev/null


# Get the available governor modes
AVAILABLE_GOVERNORS=($(cat $GOVERN | sort -u))
# Create a string of numbered governor modes
numbered_modes=""
for ((i = 0; i < ${#AVAILABLE_GOVERNORS[@]}; i++)); do
    numbered_modes+="$(($i + 1)).${AVAILABLE_GOVERNORS[i]}"
    if [[ $i -ne $(( ${#AVAILABLE_GOVERNORS[@]} - 1 )) ]]; then
        numbered_modes+=" "
    fi
done
# Display the available governor modes with numbers
printf "Set the CPU governor mode ($numbered_modes) - Currently '$(cat $CURGOV | sort -u | sed 's/schedutil/default/g')': "
read -r selected_mode_number
# Validate the user input
if [[ $selected_mode_number =~ ^[0-9]+$ && $selected_mode_number -ge 1 && $selected_mode_number -le ${#AVAILABLE_GOVERNORS[@]} ]]; then
    GOVSEL="${AVAILABLE_GOVERNORS[selected_mode_number - 1]}"
    printf "$GOVSEL" | sed 's/default/schedutil/g' | tee $CURGOV >/dev/null
    printf "CPU governor mode set to $GOVSEL\n"
fi


#
## Print the result of READ into each CPU's scaling governor mode for each available CPU.
  printf "$GOVSEL" |\
    sed 's/default/schedutil/g' |\
    tee $CURGOV >\
    /dev/null


#
## DONE
fi

