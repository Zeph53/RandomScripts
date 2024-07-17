#!/bin/bash

cpucurrentgov="/sys/devices/system/cpu/cpufreq/policy*/scaling_governor"
cpuspeednow="/sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq"
cpuspeedmin="/sys/devices/system/cpu/cpufreq/policy*/scaling_min_freq"
cpuspeedmax="/sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq"
printf " $(\
  cat $cpuspeednow |\
    awk '{sum += $1} END {printf "%09.4fMHz",sum/NR/1000}') "
printf "\n"
printf " $(\
  cat $cpuspeedmin |\
    awk '{sum += $1} END {printf "%04d",sum /NR/1000}')-$(cat $cpuspeedmax |\
      awk '{sum += $1} END {printf "%04dMHz",sum /NR/1000}') "
