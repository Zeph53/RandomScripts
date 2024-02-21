#!/bin/bash

# Function to detect and open terminal based on available options
open_terminal() {
    if [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
        xfce4-terminal --title "System-Upgrade" -e $1
    elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
        gnome-terminal -- bash -c "$1; read -s -n 1 -p 'Press any key to exit...'"
    elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
        konsole -e bash -c "$1; read -s -n 1 -p 'Press any key to exit...'"
    else
        echo "No compatible terminal found for your desktop environment."
        exit 1
    fi
}

# Function to perform the system upgrade process
perform_upgrade() {
    # Update package sources
    printf "\nStarting sources update...\n"
    apt-get update | grep -E "Hit|Get|Err|Fetched"
    printf "Done sources update!\n"

    # List upgradable packages
    printf "\nListing upgradable packages...\n"
    apt list --upgradable

    # Ask for confirmation or wait for 30 seconds to continue
    read -s -r -t 30 -p "Press enter/return or wait 30 seconds to continue..."
    printf "\nContinuing...\n"

    # Start packages upgrade
    printf "\nStarting packages upgrade...\n"
    apt-mark minimize-manual -y > /dev/null 2>&1
    apt-mark manual $(apt-get -s autoremove 2>/dev/null | awk "/^Remv / { print \$2 }") > /dev/null 2>&1
    dpkg --configure -a
    apt-get install --fix-broken -y > /dev/null 2>&1
    APT_LISTCHANGES_FRONTEND=none apt full-upgrade -y
    printf "Done packages upgrade!\n\n"

    # Wait for user input before exiting
    read -s -n 1 -p "Press any key to exit..."
    exit
}

# Execute the system upgrade process within a compatible terminal
open_terminal perform_upgrade
