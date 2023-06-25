#!/bin/bash

#
##
POLICYNUM="/sys/devices/system/cpu/cpufreq"
CORENUM="/sys/devices/system/cpu"

bash -i -c "
echo 'powersave' | tee $POLICYNUM/*/scaling_governor
echo '$(head -q -n 1 $POLICYNUM/*/cpuinfo_min_freq)' | tee $POLICYNUM/*/scaling_min_freq 
echo '$(head -q -n 1 $POLICYNUM/*/cpuinfo_max_freq)' | tee $POLICYNUM/*/scaling_max_freq
echo "0" | tee -i "$CORENUM/cpu[1-3]*/online"
echo "1" | tee -i "$CORENUM/cpu[1-3]*/online"
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=0"
nvidia-settings -a "[gpu:0]/GPUFanControlState=0
nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=50"
nvidia-settings -a "[gpu:0]/GPULogoBrightness=50"

nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/nvclock=1150
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/nvclockmin=135
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/nvclockmax=1306
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/nvclockeditable=0
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/memclock=3505
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/memclockmin=3505
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/memclockmax=3505
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/memclockeditable=0
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/memTransferRate=7010
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/memTransferRatemin=7010
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/memTransferRatemax=7010
nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString/memTransferRateeditable=0
"
