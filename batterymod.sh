#!/bin/bash
DFOLDER=~/Stuff/Myprojects/batterymod/test/  #for debug, change
NUMBUH=0
SESSION_NO=0
mkdir -p $DFOLDER

#Battery status
BATTSTATUS="$(pmset -g ps | grep -o  '..%' | sed -e 's/%//g')"
LOWBATTERY=10
if  [[ "$BATTSTATUS" -lt "$LOWBATTERY" &&  "$BATTSTATUS" -ne "00" ]]
then
    osascript -e "display notification \"Battery power is lower than $LOWBATTERY percent.\""
fi

#Screen status
FINAL_SCREENSTATE="on"
SCREENSTATUS=$(pmset -g log | grep -E 'turned on|turned off' | grep  -A60 "$(date -v-1M '+%Y-%m-%d %H:%M';)" | tail -n1 | awk '{print $8}')
if [[ ! -z "$SCREENSTATUS"  ]]
then
    echo $(date) pmset gave $SCREENSTATUS, final set to this >>"$DFOLDER"log.txt
    FINAL_SCREENSTATE=$SCREENSTATUS
else
    echo $(date) pmset gave nothing, final is $FINAL_SCREENSTATE >>"$DFOLDER"log.txt
fi

#Screenshot
