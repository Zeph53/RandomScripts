#!/bin/bash

export PKGDIR="/media/Multimedia-A/Backups/Packages/Windows"
export VC="$PGKDIR/VCRedist"
export WINEPREFIX="/media/Multimedia-Z/Prefix/64-addon"
export WINEARCH="win64"

rm -r -f "$WINEPREFIX" ;

winecfg -v win10 ;
winetricks --force --unattended fonts \
dotnet48 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 ; 

winecfg -v win7 ; 
wine "$VC/2005/vcredist_x64.exe /Q" ; 
wine "$VC/2008/vcredist_x64.exe /q" ; 
wine "$VC/2010/vcredist_x64.exe /q" ; 
wine "$VC/2012/vcredist_x64.exe /quiet" ; 
wine "$VC/2013/vcredist_x64.exe /quiet" ;

winecfg -v win10 ; 
winetricks --force --unattended d3dx9 directplay dxvk xinput ;
