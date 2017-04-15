#!/bin/bash
#Copy this to a separate location for cron to use, so ongoing development won't affect it, note the places labelled "for debug"

DFOLDER=~/Stuff/Myprojects/batterymod/test/  #for debug
#DFOLDER=~/Desktop/batterymod_log/  #for running

mkdir -p $DFOLDER && mkdir -p "$DFOLDER"session 

compareModDate ()
{
    VAR=$1
    CUR_DATE=$(date -j -f "%a %b %d %T %Z %Y" "$(date)" "+%s")
    COMP_MOD_DATE=$(($CUR_DATE - $VAR))
}

variableReset ()
{
    NUMBUH=0
    SESSION_NO=0
    echo $NUMBUH >"$DFOLDER"session/main.txt 
    echo $SESSION_NO >>"$DFOLDER"session/main.txt
    if [[ -f "$DFOLDER"session/screenstatus.txt ]]
    then
        rm "$DFOLDER"session/screenstatus.txt
    fi
    echo $(date) variables resseted >>"$DFOLDER"session/log.txt
}

#Session data
if [[ ! -f "$DFOLDER"session/main.txt ]]
then
    variableReset
else
    MOD_DATE=$(ls -lT "$DFOLDER"session/main.txt | awk '{print $6, $7, $8, $9}')
    MOD_DATE=$(date -j -f "%b %d %T %Y" "$MOD_DATE" "+%s")
    compareModDate $MOD_DATE
    if [[ "$COMP_MOD_DATE" -gt "120" ]]
    then
        variableReset
    else
        NUMBUH=$(head -n1 "$DFOLDER"session/main.txt)
        SESSION_NO=$(tail -n1 "$DFOLDER"session/main.txt)
        echo $(date) variables retrieved >>"$DFOLDER"session/log.txt
    fi
fi

#Battery status
BATTSTATUS=$(pmset -g ps | grep -o  '..%' | sed -e 's/%//g') #quotes removed here, not tested
LOWBATTERY=10
if [[ "$BATTSTATUS" -lt "$LOWBATTERY" &&  "$BATTSTATUS" -ne "00" ]]
then
    osascript -e "display notification \"Battery power is lower than $LOWBATTERY percent.\" with title \"Batterymod\""
fi

#Screen status
if [[ -f "$DFOLDER"session/screenstatus.txt ]]
then 
    FINAL_SCREENSTATE=$(cat "$DFOLDER"session/screenstatus.txt)
    echo $(date) FINAL_SCREENSTATE retreived and is $FINAL_SCREENSTATE >>"$DFOLDER"session/log.txt
else
    FINAL_SCREENSTATE="on"
fi
SCREENSTATUS=$(pmset -g log | grep -E 'turned on|turned off' | grep  -A60 "$(date -v-1M '+%Y-%m-%d %H:%M';)" | tail -n1 | awk '{print $8}')
if [[ ! -z "$SCREENSTATUS"  ]]
then
    echo $(date) pmset gave $SCREENSTATUS, final set to this >>"$DFOLDER"session/log.txt
    echo $SCREENSTATUS >"$DFOLDER"session/screenstatus.txt
else
    echo $(date) pmset gave nothing, final is $FINAL_SCREENSTATE >>"$DFOLDER"session/log.txt
fi

#Screenshot
if [[ "$FINAL_SCREENSTATE" == "on" ]]
then 
    #caffeinate -imt 70 &   not working, not worth it. already have made it essentially sleep-proof via variable resetting?
    if [[ "$NUMBUH" -eq "10" ]] #at smaller query-time values, there's an additional second to account for running this itself; 
                                #so a 5 second query would required 100 not 120 for every ten minutes
    then
        SSDATE=$(date '+%Y-%m-%d_%H-%M')
        /usr/sbin/screencapture -x "$DFOLDER""$SSDATE".png #for debug
        echo $(date) screenshot "$DFOLDER""$SSDATE".png attempted >>"$DFOLDER"session/log.txt 
        osascript -e "display notification \"Logged (test).\" with title \"Batterymod\""  #for debug
        #osascript -e "display notification \"Logged.\" with title \"Batterymod\""  #for running
        NUMBUH=1 && SESSION_NO=$(($SESSION_NO + 1))
        echo $NUMBUH >"$DFOLDER"session/main.txt
        echo $SESSION_NO >>"$DFOLDER"session/main.txt        
        echo $(date) Reached 10: sessions are $SESSION_NO and units are $NUMBUH  >>"$DFOLDER"session/log.txt
    else
        NUMBUH=$(($NUMBUH + 1))
        echo $NUMBUH >"$DFOLDER"session/main.txt
        echo $SESSION_NO >>"$DFOLDER"session/main.txt        
        echo $(date) Counting: sessions are $SESSION_NO and units are $NUMBUH  >>"$DFOLDER"session/log.txt
    fi
else
    #pkill caffeinate
    echo $(date) total sessions was $SESSION_NO  and lost so many units: $NUMBUH  >>"$DFOLDER"session/log.txt
    NUMBUH=0 && SESSION_NO=0
    echo $NUMBUH >"$DFOLDER"session/main.txt
    echo $SESSION_NO >>"$DFOLDER"session/main.txt        
fi
