#!/bin/bash
#Copy this to a separate location for cron to use, so ongoing development won't affect it, note the places labelled "for debug"

DFOLDER=~/Stuff/Myprojects/batterymod/test/  #for debug
#DFOLDER=~/Desktop/batterymod_log/  #for running

mkdir -p $DFOLDER

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
    echo $NUMBUH >"$DFOLDER"session.txt 
    echo $SESSION_NO >>"$DFOLDER"session.txt
    if [[ -f "$DFOLDER"screenstatus.txt ]]
    then
        rm "$DFOLDER"screenstatus.txt
    fi
    echo $(date) variables resseted >>"$DFOLDER"log.txt
}

#Session data
if [[ ! -f "$DFOLDER"session.txt ]]
then
    variableReset
else
    MOD_DATE=$(ls -lT "$DFOLDER"session.txt | awk '{print $6, $7, $8, $9}')
    MOD_DATE=$(date -j -f "%b %d %T %Y" "$MOD_DATE" "+%s")
    compareModDate $MOD_DATE
    if [[ "$COMP_MOD_DATE" -gt "120" ]]
    then
        variableReset
    else
        NUMBUH=$(head -n1 "$DFOLDER"session.txt)
        SESSION_NO=$(tail -n1 "$DFOLDER"session.txt)
        echo $(date) variables retrieved >>"$DFOLDER"log.txt
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
if [[ -f "$DFOLDER"screenstatus.txt ]]
then 
    FINAL_SCREENSTATE=$(cat "$DFOLDER"screenstatus.txt)
    echo $(date) FINAL_SCREENSTATE retreived and is $FINAL_SCREENSTATE >>"$DFOLDER"log.txt
else
    FINAL_SCREENSTATE="on"
fi
SCREENSTATUS=$(pmset -g log | grep -E 'turned on|turned off' | grep  -A60 "$(date -v-1M '+%Y-%m-%d %H:%M';)" | tail -n1 | awk '{print $8}')
if [[ ! -z "$SCREENSTATUS"  ]]
then
    echo $(date) pmset gave $SCREENSTATUS, final set to this >>"$DFOLDER"log.txt
    echo $SCREENSTATUS >"$DFOLDER"screenstatus.txt
else
    echo $(date) pmset gave nothing, final is $FINAL_SCREENSTATE >>"$DFOLDER"log.txt
fi

#Screenshot
if [[ "$FINAL_SCREENSTATE" == "on" ]]
then 
    if [[ "$NUMBUH" -eq "10" ]] #at smaller query-time values, there's an additional second to account for running this itself; 
                                #so a 5 second query would required 100 not 120 for every ten minutes
    then
        SSDATE=$(date '+%Y-%m-%d_%H-%M')
        /usr/sbin/screencapture -x "$DFOLDER""$SSDATE".png #for debug
        echo $(date) screenshot "$DFOLDER""$SSDATE".png attempted >>"$DFOLDER"log.txt 
        osascript -e "display notification \"Logged (test).\" with title \"Batterymod\""  #for debug
        #osascript -e "display notification \"Logged.\" with title \"Batterymod\""  #for running
        NUMBUH=1
        SESSION_NO=$(($SESSION_NO + 1))
        echo $NUMBUH >"$DFOLDER"session.txt
        echo $SESSION_NO >>"$DFOLDER"session.txt        
        echo $(date) Reached 10: sessions are $SESSION_NO and units are $NUMBUH  >>"$DFOLDER"log.txt
    else
        NUMBUH=$(($NUMBUH + 1))
        echo $NUMBUH >"$DFOLDER"session.txt
        echo $SESSION_NO >>"$DFOLDER"session.txt        
        echo $(date) Counting: sessions are $SESSION_NO and units are $NUMBUH  >>"$DFOLDER"log.txt
    fi
else
    echo $(date) total sessions was $SESSION_NO  and lost so many units: $NUMBUH  >>"$DFOLDER"log.txt
    NUMBUH=0
    SESSION_NO=0
    echo $NUMBUH >"$DFOLDER"session.txt
    echo $SESSION_NO >>"$DFOLDER"session.txt        
fi
