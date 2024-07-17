#!/bin/bash

#
##

pdir="$(dirname "$(dirname "$0")")"
menu="$(echo "$(grep '"$answer" = ' "$0" | grep -v 'menu=')" | awk -F ' ' '{print $5}' | sed -z 's/"//g')"
answer="`zenity --list --column '' --hide-header --width 250 --height 500 "${menu[@]}"`"

if [[ "$answer" == "Launch" ]]
then
    "$pdir/mb_warband.sh"
    "$0"
fi

if [[ "$answer" == "Vanilla-Options" ]]
then
    "$pdir/mbw_config.sh"
    "$0"
fi

#if [ "$answer" = "Options" ]
#then
#    mbconf="$HOME/.mbwarband/rgl_config.txt"
#    menuentries="$(awk -F ' ' '/./{print $1 " " $3}' "$mbconf" | sort)"
#    option=`zenity --list --separator " = " --column "Setting" --column "Value" --print-column "ALL" --width "500" --height "500" "$menuentries"`
#    if [ "$option" ]
#    then
#        seloption="$(printf "$option" | awk -F ' ' '{print $1}')"
#        seloptdef="$(printf "$menuentries" | grep "$seloption" | awk -F ' ' '{print $2}')"
#        seloptval=`zenity --entry --text "$seloption" --entry-text "$seloptdef" --width "50" --height "50"`
#        sed -i 's/'"$seloption"' = '"$seloptdef"'/'"$seloption"' = '"$seloptval"'/g' "$mbconf"
#        "$0"
#        echo "$seloption"
#        echo "$seloptdef"
#        echo "$seloptval"
#    fi
#fi

if
  [[ "$answer" == "Options" ]]
then
fi
