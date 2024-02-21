#!/bin/bash

ramused=$(free --si --mega | grep Mem | awk '{printf "%04.1f", $3/1024}')
ramtotal=$(free --si --mega | grep Mem | awk '{printf "%04.1fGB", $2/1024}')
swapused=$(free --si --mega | grep Swap | awk '{printf "%04.2f", $3/1024}')
swaptotal=$(free --si --mega | grep Swap | awk '{printf "%04.2fGB", $2/1024}')
printf " $ramused/$ramtotal "
printf "\n"
printf " $swapused/$swaptotal "
