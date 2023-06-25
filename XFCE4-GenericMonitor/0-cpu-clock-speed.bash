#!/bin/bash

#
##

#
## Grab MHz of all cores 
$bash -i -c \'
grep -q "0" "/sys/devices/system/cpu/online" &&
C0="$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq)"
grep -q "1" "/sys/devices/system/cpu/cpu1/online" &&
C1="$(cat /sys/devices/system/cpu/cpufreq/policy1/scaling_cur_freq)"
grep -q "1" "/sys/devices/system/cpu/cpu2/online" &&
C2="$(cat /sys/devices/system/cpu/cpufreq/policy2/scaling_cur_freq)"
grep -q "1" "/sys/devices/system/cpu/cpu3/online" &&
C3="$(cat /sys/devices/system/cpu/cpufreq/policy3/scaling_cur_freq)"
printf $C0 $C1 $C2 $C3 |
awk '{sum+=$NF+0} END{print sum/NR}' |
sed 's/.\{3\}$//' |
sed 's/\..*$//' |
sed -e 's:^:0000:' -e 's:0\+\(.\{4\}\)$:\1:' |
sed 's/\..*$//' |
sed 's/$/MHz/'
\'

#
## Displays the current governor
$bash -i -c \'
CURGOV="/sys/devices/system/cpu/cpufreq/policy*/scaling_governor"
cat $CURGOV |
sort -u |
sed 's/powersave/Pwrsave/' |
sed 's/performance/Perform/' |
sed 's/schedutil/Default/'
\'
