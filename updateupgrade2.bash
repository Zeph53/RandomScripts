#!/bin/bash

xfce4-terminal --title "System-Upgrade" --execute bash -i -c '

cd $HOME

sleep 1 | printf "\nStarting sources update...\n"
apt-get update | grep "Hit\|Get\|Err\|Fetched"
sleep 1 | printf "Done sources update!\n"

printf "\nListing upgradable packages...\n"
apt list --upgradable
read -s -r -t 30 -p "Press enter/return or wait 30 seconds to continue..."
sleep 1 | printf "\nContinuing...\n"

printf "\nStarting packages upgrade...\n"
apt-mark minimize-manual -y > /dev/null 2>&1
apt-mark manual $(apt-get -s autoremove 2>/dev/null | awk "/^Remv / { print $2 }") > /dev/null 2>&1
dpkg --configure -a
apt-get install --fix-broken -y > /dev/null 2>&1
APT_LISTCHANGES_FRONTEND=none apt full-upgrade -y
sleep 1 | printf "Done packages upgrade!\n\n"

read -s -r -t 30 -p "Press enter/return to revert to default shell or wait 30 seconds for exit..." &&
$SHELL > /dev/tty 2>&2 1>&1 | printf "\nReverting to default shell...\n\n" ||
sleep 3 | printf "\nExiting..."

exit
'
