#!/bin/bash

#
## Description

#
## Displays the current battery level
$bash -i -c \'
CURRENTBAT="$(cat /sys/class/power_supply/BAT0/energy_now)"
printf "$CURRENTBAT" | 
sed -e 's:^:0:' |
sed 's/./&./2' |
sed 's/.\{4\}$//' | 
sed 's/$/Wh/'
\'

printf "/"

#
## Display the maximum amount of battery
$bash -i -c \'
MAXBAT="$(cat /sys/class/power_supply/BAT0/energy_full)"
printf "$MAXBAT" | 
sed 's/./&./2' |
sed 's/.\{4\}$//' | 
sed 's/$/Wh/'
\'

printf "\n"

#
## Print minutes remaining
$bash -i -c \'
REMAINING="$( upower -i /org/freedesktop/UPower/devices/battery_BAT0 | 
grep "time to empty" |
sed -e 's:^:0:' |
sed "s/ //g" |
sed "s/timetoempty://g" |
sed "s/minutes//g" |
sed "s/$/Mi/g" )"
printf "$REMAINING"
\'

printf "/"

#
## Print current voltage
$bash -i -c \'
VOLTAGE="$( cat /sys/class/power_supply/BAT0/voltage_now )"
printf "$VOLTAGE" |
sed 's/.\{3\}$//' |
sed 's/./&./2' |
sed "s/$/V/g"
\'
