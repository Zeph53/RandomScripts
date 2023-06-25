#!/bin/bash

#
##
POLICYNUM="/sys/devices/system/cpu/cpufreq"
CORENUM="/sys/devices/system/cpu"

bash -i -c "
echo 'powersave' | tee $POLICYNUM/*/scaling_governor
echo '$(head -q -n 1 $POLICYNUM/*/cpuinfo_min_freq)' | tee $POLICYNUM/*/scaling_min_freq 
echo '$(head -q -n 1 $POLICYNUM/*/cpuinfo_min_freq | awk '{print $0+200000}')' | tee $POLICYNUM/*/scaling_max_freq
echo "0" | tee -i "$CORENUM/cpu[1-3]*/online"
echo "1" | tee -i "$CORENUM/cpu[2-2]*/online"
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=0"
nvidia-settings -a "[gpu:0]/GPUFanControlState=1"
nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=1"
nvidia-settings -a "[gpu:0]/GPULogoBrightness=0"

nvidia-settings -a "[gpu:0]/GPUCurrentClockFreqsString=nvclock=1150, nvclockmin=130, nvclockmax=135, nvclockeditable=0, memclock=3505, memclockmin=3505, memclockmax=3505, memclockeditable=0, memTransferRate=7010, memTransferRatemin=7010, memTransferRatemax=7010, memTransferRateeditable=0"

nvidia-settings -a "[debian:0.0]/CurrentMetaMode=id=50, switchable=yes, source=xconfig :: DPY-2: nvidia-auto-select @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceCompositionPipeline=On"

"
