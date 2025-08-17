#!/bin/bash

mt5exe='/data/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe'
WINEPREFIX=/data/.wine

# Test if MT5 executable file already exists
if [ -e "$mt5exe" ]; then
    echo "File $mt5exe already exists"
else
    echo "File $mt5exe does not exist"
    # Run "wine install.exe" if mt5 does not exists
    mkdir -p /data/.wine/drive_c
    curl -o /data/.wine/drive_c/mt5setup.exe https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe
    if [ -e "/data/.wine/drive_c/windows/mono" ]; then
        echo "MONO is already installed"
    else
        curl -o ~/.wine/drive_c/mono-8.0.0.msi https://dl.winehq.org/wine/wine-mono/8.0.0/wine-mono-8.0.0-x86.msi
        WINEDLLOVERRIDES=mscoree=d wine msiexec /i ~/.wine/drive_c/mono-8.0.0.msi /qn
        rm ~/.wine/drive_c/mono-8.0.0.msi
        echo "Installed MONO"
    fi
    exec wine "/data/.wine/drive_c/mt5setup.exe" "/auto" &
    wait
fi

# Check that file exists now
if [ -e "$mt5exe" ]; then
    echo "MT5 is installed"
    # Delete MT5 setup file
    rm -f /data/.wine/drive_c/mt5setup.exe
    # run "wine terminal64.exe"
    wine "$mt5exe"
else
    echo "File {$mt5exe} does not exist yet. This is probably caused by an installation error. MT5 cannot run"
fi
