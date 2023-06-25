#!/bin/bash

export SCRIPTDIR="$(dirname "$(readlink -f "$0")")"

MENU=("FalloutNV" "GECK" "FNVEdit" "FNVEdit-Autoclean" "FNVEdit-LODGen" "NifSkope" "Generate-Prefix") ;
ANSWER=`zenity --list --column='' --hide-header --height 500 "${MENU[@]}"` ;

if [ "$ANSWER" = "FalloutNV" ]; then
#    export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1="1"
#    export SDL_VIDEO_FULLSCREEN_DISPLAY="off"
#    export LD_LIBRARY_PATH="/usr/lib:/usr/lib64:/lib/x86_64-linux-gnu:/lib/i386-linux-gnu:/lib:/lib32:/lib/i386-linux-gnu/i686/sse2:/lib/i386-linux-gnu/sse2:/usr/lib/x86_64-linux-gnu/libfakeroot:/lib64:/lib64:/usr/lib:/usr/lib64:/usr/lib32:/usr/lib64:/usr/lib/i386-linux-gnu:/usr/lib/x86_64-linux-gnu:/root/.local/share/lutris/runtime/Ubuntu-18.04-i686:/root/.local/share/lutris/runtime/steam/i386/lib/i386-linux-gnu:/root/.local/share/lutris/runtime/steam/i386/lib:/root/.local/share/lutris/runtime/steam/i386/usr/lib/i386-linux-gnu:/root/.local/share/lutris/runtime/steam/i386/usr/lib:/root/.local/share/lutris/runtime/Ubuntu-18.04-x86_64:/root/.local/share/lutris/runtime/steam/amd64/lib/x86_64-linux-gnu:/root/.local/share/lutris/runtime/steam/amd64/lib:/root/.local/share/lutris/runtime/steam/amd64/usr/lib/x86_64-linux-gnu:/root/.local/share/lutris/runtime/steam/amd64/usr/lib:$LD_LIBRARY_PATH"
#    export DXVK_NVAPIHACK="0"
#    export DXVK_HUD="fps"
#    export WINEESYNC="1"
#    export WINEFSYNC="0"
#    export WINE_LARGE_ADDRESS_AWARE="1"
#    export WINEDEBUG="-all"
#    export WINEDLLOVERRIDES="winemenubuilder="
#    export MANGOHUD="1"
#    export MANGOHUD_DLSYM="1"
#    export MANGOHUD_CONFIG="background_alpha=0,position=top-right,frametime=0,cpu_stats=0,gpu_stats=0,no_small_font,frame_timing=0,width=128,fps_only,table_columns=1"
    wine $SCRIPTDIR/nvse_loader.exe -altexe FalloutNV4GB.exe | $0 ;
fi

if [ "$ANSWER" = "GECK" ]; then
    export WINEPREFIX="$SCRIPTDIR/WinePrefix"
    wine $SCRIPTDIR/nvse_loader.exe -editor | $0 ;
fi

if [ "$ANSWER" = "FNVEdit" ]; then
    export WINEPREFIX="$SCRIPTDIR/WinePrefix"
    wine $SCRIPTDIR/../FNVEdit*/FNVEdit.exe -D:$SCRIPTDIR/Data -I:$SCRIPTDIR/Fallout_default.ini -P:$SCRIPTDIR/../FNVEdit/Plugin.txt | $0 ; 
fi

if [ "$ANSWER" = "FNVEdit-Autoclean" ]; then
    export WINEPREFIX="$SCRIPTDIR/WinePrefix"
    wine $SCRIPTDIR/../FNVEdit*/FNVEditQuickAutoClean.exe -D:$SCRIPTDIR/Data -I:$SCRIPTDIR/Fallout_default.ini -P:$SCRIPTDIR/../FNVEdit/Plugin.txt | $0 ; 
fi

if [ "$ANSWER" = "FNVEdit-LOD-Gen" ]; then
    export WINEPREFIX="$SCRIPTDIR/WinePrefix"
    wine $SCRIPTDIR/../FNVEdit*/FNVLODGen.exe -D:$SCRIPTDIR/Data -I:$SCRIPTDIR/Fallout_default.ini -P:$SCRIPTDIR/../FNVEdit/Plugin.txt -o:$SCRIPTDIR/Data/GENERATED-LOD | $0 ; 
fi

if [ "$ANSWER" = "NifSkope" ]; then
    export WINEPREFIX="$SCRIPTDIR/WinePrefix"
    wine $SCRIPTDIR/../NifSkope*/NifSkope.exe | $0 ; 
fi

if [ "$ANSWER" = "Generate-Prefix" ]; then
    export WINEARCH=win64
    export WINEPREFIX="$SCRIPTDIR/WinePrefix"
    export PKGDIR="/media/Multimedia-A/Backups/Packages/Windows"
    rm -r -d $WINEPREFIX ;
    winecfg -v win7 ;
    winetricks isolate_home
    winetricks --force --unattended corefonts dotnet48
#    ## Install dotNET
#    export DOT="$PGKDIR/DotNET"
#    winecfg -v winxp $PK
#    wine $DOT/dotnetfx35.exe /q $PK
#    winecfg -v win7 $PK
#    wine $DOT/dotNetFx40_Full_x86_x64.exe /q $PK
#    wine $DOT/dotnetfx45_full_x86_x64.exe /q $PK
#    winecfg -v win10 $PK
#    wine $DOT/NDP46-KB3045557-x86-x64-AllOS-ENU.exe /q $PK
#    wine $DOT/ndp48-x86-x64-allos-enu.exe /q $PK
#    wine $DOT/NDP461-KB3102436-x86-x64-AllOS-ENU.exe /q $PK
#    wine $DOT/NDP462-KB3151800-x86-x64-AllOS-ENU.exe /q $PK
#    wine $DOT/NDP472-KB4054530-x86-x64-AllOS-ENU.exe /q $PK
#    winecfg -v win7 $PK
    ## Install VCREDIST x86
    export VC="$PGKDIR/VCRedist"
    winecfg -v winxp ;
    wine $VC/2005/vcredist_x86.exe /Q ;
    wine $VC/2008/vcredist_x86.exe /q ;
    winecfg -v win7 ;
    wine $VC/2010/vcredist_x86.exe /q ;
    wine $VC/2012/vcredist_x86.exe /quiet ;
    wine $VC/2013/vcredist_x86.exe /quiet ;
    ## Install VCREDIST x64
    winecfg -v winxp ;
    wine $VC/2005/vcredist_x64.exe /Q ;
    wine $VC/2008/vcredist_x64.exe /q ;
    winecfg -v win7 ;
    wine $VC/2010/vcredist_x64.exe /q ;
    wine $VC/2012/vcredist_x64.exe /quiet ;
    wine $VC/2013/vcredist_x64.exe /quiet ;
    ## Install DirectX
    export DX="$PKGDIR/DirectX"
    wine $DX/DXSETUP.exe /silent ;
    ## Install Vulkan
    export VK="$PKGDIR/Vulkan"
    winetricks --force --unattended dxvk ;
    winecfg -v win7 ;
    printf "\nDONE\n" ;
    ## Reopen menu
    $0
fi
