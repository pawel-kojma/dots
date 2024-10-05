#!/usr/bin/env bash

ID=$(xinput --list | grep -i 'touchpad' | sed -r 's/.*id=([0-9]+).*/\1/')

if [ $1 == 'enable' ]; then
    xinput --enable $ID
elif [ $1 == 'disable' ]; then
    xinput --disable $ID
else
    exit 1
fi
