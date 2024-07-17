#!/bin/bash

#
##
export DIR="$(dirname "$(readlink -f "$0")")" && pwd

MENU=\
($(echo "$(grep '"$ANSWER" = ' $0 | grep -v 'MENU=')" | \
awk -F ' ' '{print $5}' | sed -z 's/"//g')) ;

ANSWER=\
`zenity --list --column '' --hide-header --width 200 --height 250 "${MENU[@]}"` ;

if [ "$ANSWER" = "Launch" ]; then
    "$DIR/../mb_warband.sh" ;
    $0 ;
fi

if [ "$ANSWER" = "Vanilla-Options" ]; then
    "$DIR/../mbw_config.sh" ;
    $0 ;
fi





if [ "$ANSWER" = "Options" ]; then
    MBCONF="$HOME/.mbwarband/rgl_config.txt"
    OPTMENU=($(echo "$(grep '"$OPTION" = ' $0 | grep -v 'OPTMENU=')" | awk -F ' ' '{print $5}' | sed -z 's/"//g')) ;
    OPTION=`zenity --list --column '' --hide-header --width 200 --height 250 "${OPTMENU[@]}"` ;

    if [ "$OPTION" = "Set-Display-Width" ]; then
        DEFWIDTH="$(grep -Eo '^display_width = *[0-9]+' $MBCONF | grep -o '[0-9]*')"
        RESWIDTH="$(zenity --scale --step 1 --value $DEFWIDTH --min-value 640 --max-value 2560)"
        if [[ $? == 0 ]]; then
            sed -i "s/^display_width = .*$/display_width = $RESWIDTH/" $MBCONF ;
        fi
        $0 ;
    fi
    if [ "$OPTION" = "Set-Display-Height" ]; then
        DEFHEIGHT="$(grep -Eo '^display_height = *[0-9]+' $MBCONF | grep -o '[0-9]*')"
        RESHEIGHT="$(zenity --scale --step 1 --value $DEFHEIGHT --min-value 640 --max-value 2560)"
        if [[ $? == 0 ]]; then
            sed -i "s/^display_height = .*$/display_height = $RESHEIGHT/" $MBCONF ;
        fi
        $0 ;
    fi
fi
