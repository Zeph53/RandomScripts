#!/bin/bash

if grep "PLAYSTATION(R)3" /sys/class/bluetooth/hci0:*/*/uevent > /dev/null ;
then
    sleep 0
else
    printf "failed"
fi
