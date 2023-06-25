#!/bin/bash

#
##
POLICYNUM="/sys/devices/system/cpu/cpufreq"
CORENUM="/sys/devices/system/cpu"

$bash -i -c \'
echo 'schedutil' | tee $POLICYNUM/*/scaling_governor ;
sleep 1 ;
echo '$(head -q -n 1 $POLICYNUM/*/cpuinfo_min_freq)' | tee $POLICYNUM/*/scaling_min_freq ;
echo '$(head -q -n 1 $POLICYNUM/*/cpuinfo_max_freq)' | tee $POLICYNUM/*/scaling_max_freq ;
echo "1" | tee -i "$CORENUM/cpu[1-3]*/online"
#nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=0"
#nvidia-settings -a "[gpu:0]/GPUFanControlState=0"
#nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=50"
#nvidia-settings -a "[gpu:0]/GPULogoBrightness=50"
\'
