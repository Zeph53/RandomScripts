#!/bin/bash

#
## A simple script to set CPU speed 
#
## Environment variables.
CPUMIN="/sys/devices/system/cpu/cpufreq/policy*/cpuinfo_min_freq"
CPUMAX="/sys/devices/system/cpu/cpufreq/policy*/cpuinfo_max_freq"
CSCALE="/sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq"
GOVERN="/sys/devices/system/cpu/cpufreq/policy*/scaling_available_governors"
CURGOV="/sys/devices/system/cpu/cpufreq/policy*/scaling_governor"
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
    cat $CSCALE |\
      awk '{for(i=1;i<=NF;i++){sum+=$i;num++}}END{print(sum/num)}' |\
      sed 's/...$//g')\": ")"\
  SETMAXSCALE
#
## Print the result of READ into each CPU's scaling factor for each available CPU.
printf "$SETMAXSCALE" |\
  sed 's/$/000/g' |\
  tee $CSCALE >\
  /dev/null
#
## Prompts the user to choose a governor using READ and scans for all governor modes.
read -e -p "$(\
  printf "Set the CPU governor mode ($(\
    cat $GOVERN |\
      sort -u )) - Currently \"$(\
    cat $CURGOV |\
      sort -u |\
      sed 's/schedutil/default/g')\": ")"\
  GOVSEL
#
## Print the result of READ into each CPU's scaling governor mode for each available CPU.
printf "$GOVSEL" |\
  sed 's/default/schedutil/g' |\
  tee $CURGOV >\
  /dev/null
#
## DONE
