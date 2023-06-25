#!/bin/bash

#
## I was never happy with how Winecfg or Lutris handled user sandboxes so
## Here's a nice little script to symbolically link all the Wine bottles together 
## So you won't ever need to reconfigure anything
## Make sure to edit the 2 lines below according to your system

#
## Select where your Wine bottles and User sandboxes are located
export PREFIXDIR='/media/Multimedia-Z/Prefix'
export SANDBOXDIR='/media/Multimedia-Z/Sandbox'

sleep 1 ; rm -r -d $PREFIXDIR/*/drive_c/users/*/*
sleep 1 ; find $PREFIXDIR/*/drive_c/users/* -maxdepth 0 -iname '*' -type d -exec ln -s -f -- $SANDBOXDIR/* '{}' ';'
sleep 1 ; 
