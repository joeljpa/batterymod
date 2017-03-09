#!/bin/bash
LOWBATTERY=10
DFOLDER="~/Desktop/batterymod_log/"
NUMBUH=0
SESSION_NO=0
BATTSTATUS="$(pmset -g ps | grep -o  '..%' | sed -e 's/%//g')"

if  [[ "$BATTSTATUS" -lt "$LOWBATTERY" &&  "$BATTSTATUS" -ne "00" ]]
then
    osascript -e "display notification \"Battery power is lower than $LOWBATTERY percent.\""
fi
