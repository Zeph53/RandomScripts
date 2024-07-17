#!/bin/bash

#
##
#
##
wget -q -O - 'https://dl.winehq.org/wine-builds/winehq.key' | apt-key add -
apt-key adv --recv-key --keyserver 'keyserver.ubuntu.com' '96B9CD7C22E2C8C5'
wget -q -O - 'https://www.virtualbox.org/download/oracle_vbox_2016.asc' | apt-key add -
wget -q -O - 'https://packages.microsoft.com/keys/microsoft.asc' | apt-key add -
wget -q -O - 'https://content.runescape.com/downloads/ubuntu/runescape.gpg.key' | apt-key add -
wget -q -O - 'https://developer.download.nvidia.com/compute/cuda/repos/debian10/x86_64/7fa2af80.pub' | apt-key add -
