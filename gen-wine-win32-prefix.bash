#!/bin/bash

#
## I got tired of doing all of this manually
## So here you go
## Be sure to set the WINEPREFIX to your 32 bit target folder
#
## Export variables
export WINEARCH='win32' ;
export WINEPREFIX='/media/Multimedia-Z/Prefix/32-addon' ;
export ARGS='winetricks --unattended --force' ;
export SETV10='; winecfg -v win10 ; sleep 1 ;' ;
## Remove previous prefix
rm -r -f $WINEPREFIX $SETV10
## Install Windows Fonts
$ARGS allfonts $SETV10
## Install Dotnet 
$ARGS dotnet35sp1 $SETV10
$ARGS dotnet462 $SETV10
$ARGS dotnet472 $SETV10
$ARGS dotnet48 $SETV10
## Install Visual C++ Runtime
$ARGS vcrun2003 $SETV10
$ARGS vcrun2005 $SETV10
$ARGS vcrun2008 $SETV10
$ARGS vcrun2010 $SETV10
$ARGS vcrun2012 $SETV10
$ARGS vcrun2013 $SETV10
#$ARGS vcrun2015 $SETV10
#$ARGS vcrun2017 $SETV10
#$ARGS vcrun2019 $SETV10
## Install DirectX and Vulkan
$ARGS d3dx9 $SETV10
$ARGS directplay $SETV10
$ARGS vulkanrt $SETV10
$ARGS d9vk $SETV10
$ARGS dxvk $SETV10
## Install xInput
$ARGS xinput $SETV10
## Revert to default shell
$SHELL ;
cd $HOME ;
