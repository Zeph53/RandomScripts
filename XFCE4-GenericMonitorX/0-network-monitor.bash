#!/bin/bash
#
## 
$bash -i -c \'
if [ -z "$1" ]; then
    echo
    echo usage: $0 network-interface
    echo
    echo e.g. $0 eth0
    echo
    exit
fi

IF=$1
R1=`cat /sys/class/net/usb0/statistics/rx_bytes`
T1=`cat /sys/class/net/usb0/statistics/tx_bytes`
sleep 1
R2=`cat /sys/class/net/usb0/statistics/rx_bytes`
T2=`cat /sys/class/net/usb0/statistics/tx_bytes`
TBPS=`expr $T2 - $T1`
RBPS=`expr $R2 - $R1`
TKBPS=`expr $TBPS / 1024`
RKBPS=`expr $RBPS / 1024`
printf "%dK\n%dK" $1 $RKBPS $TKBPS
\'