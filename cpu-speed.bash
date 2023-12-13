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


if [ $# -eq 2 ]; then
    ARGMIN=$1
    ARGMAX=$2
    printf "$ARGMIN" |\
      sed 's/$/000/g' |\
      tee $CSCALEMIN >\
      /dev/null
    printf "$ARGMAX" |\
      sed 's/$/000/g' |\
      tee $CSCALEMAX >\
      /dev/null
    printf "Set CPU speed to $(cat $CSCALEMIN | sort -u | sed 's/...$//g')MHz - $(cat $CSCALEMAX | sort -u | sed 's/...$//g')MHz \n"
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


#
## Prompts the user to choose a governor using READ and scans for all governor modes.
#  read -e -p "$(\
#    printf "Set the CPU governor mode ($(\
#      cat $GOVERN |\
#        sort -u )) - Currently \"$(\
#      cat $CURGOV |\
#        sort -u |\
#        sed 's/schedutil/default/g')\": ")"\
#    GOVSEL


#
## Present numbered options for governor modes using select
LISTGOVERNS=($(cat $GOVERN | sort -u))
printf "Set the CPU governor mode:\n"
select mode_option in "${LISTGOVERNS[@]}"; do
    if [ -n "$mode_option" ]; then
        GOVSEL="$mode_option"
        break
    else
        echo "Invalid option. Please select a valid number."
    fi
done


#
## Print the result of READ into each CPU's scaling governor mode for each available CPU.
  printf "$GOVSEL" |\
    sed 's/default/schedutil/g' |\
    tee $CURGOV >\
    /dev/null


#
## DONE
fi

