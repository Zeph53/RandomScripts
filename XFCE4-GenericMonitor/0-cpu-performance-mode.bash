#!/bin/bash

#
##
POLICYNUM="/sys/devices/system/cpu/cpufreq"
CORENUM="/sys/devices/system/cpu"

bash -i -c "
echo 'performance' | tee $POLICYNUM/*/scaling_governor
echo '$(head -q -n 1 $POLICYNUM/*/cpuinfo_max_freq)' | tee $POLICYNUM/*/scaling_min_freq 
echo '$(head -q -n 1 $POLICYNUM/*/cpuinfo_max_freq)' | tee $POLICYNUM/*/scaling_max_freq
echo "0" | tee -i "$CORENUM/cpu[1-3]*/online"
echo '1' | tee -i $CORENUM/cpu[1-3]*/online
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1"
nvidia-settings -a "[gpu:0]/GPUFanControlState=0"
nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=100"
nvidia-settings -a "[gpu:0]/GPULogoBrightness=100"
"
