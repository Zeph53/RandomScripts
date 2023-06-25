#!/bin/bash

#
##

#
## Environment variables
export START="$SHELL -i -c sleep=1 | $(printf '"')"
export DONE="sed s/$//"
export CURFREQ="/sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq"
export CURGOV="/sys/devices/system/cpu/cpufreq/policy*/scaling_governor"

#
## Displays the current clock speed
#
## Start
#$START
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





## Remove last 3 characters 
#sed 's/.\{3\}$//' |
## Sort averages 
#awk '{sum+=$NF+0} END{print sum/NR}' |
## Remove trailing decimal 
#sed 's/\..*$//' |
## Prepend 0 for 4 digit numbers 
#sed -e 's:^:0000:' -e 's:0\+\(.\{4\}\)$:\1:' |
## Append MHz
#sed 's/$/MHz/' |
## End
#$DONE

#
## Displays the current governor
#
## Start
$START
## Grab governor value
cat $CURGOV |
## Sort the repeats
sort -u |
## Rename for elegance
sed 's/powersave/Pwrsave/' |
sed 's/performance/Perform/' |
## End
$DONE
