#!/bin/bash
#Copy this to a separate location for cron to use, so ongoing development won't affect it
DFOLDER=~/Stuff/Myprojects/batterymod/test/  #for debug, change

mkdir -p $DFOLDER

#Battery status
BATTSTATUS=$(pmset -g ps | grep -o  '..%' | sed -e 's/%//g') #quotes removed here, not tested
LOWBATTERY=10
if [[ "$BATTSTATUS" -lt "$LOWBATTERY" &&  "$BATTSTATUS" -ne "00" ]]
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
NUMBUH=0
SESSION_NO=0
if [[ "$FINAL_SCREENSTATE" -eq "on" ]]
then 
    if [[ "$NUMBUH" -eq "10" ]] #at smaller query-time values, there's an additional second to account for running this itself; 
                                #so a 5 second query would required 100 not 120 for every ten minutes
    then
        SSDATE=$(date '+%Y-%m-%d_%H-%M')
        /usr/sbin/screencapture -x "$DFOLDER""$SSDATE".png
        echo $(date) screenshot "$DFOLDER""$SSDATE".png attempted >>"$DFOLDER"log.txt
        osascript -e "display notification \"Logged.\""
        NUMBUH=1
        SESSION_NO=$(($SESSION_NO + 1))
    else
        NUMBUH=$(($NUMBUH + 1))
    fi
else
    echo $(date) total sessions was $SESSION_NO  and lost so many units: $NUMBUH  >>"$DFOLDER"log.txt
    NUMBUH=0
    SESSION_NO=0
fi
