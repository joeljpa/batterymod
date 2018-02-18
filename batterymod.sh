#!/bin/bash

#version 0.41
#Copy this to a separate location for cron to use, so ongoing development won't affect it

DEBUG=0
if [[ $1 -eq 1 ]] 
then
    DEBUG=1
fi

if [[ $DEBUG -eq 1 ]]
then 
    DFOLDER=~/Stuff/Myprojects/batterymod/test/
else
    DFOLDER=~/Desktop/batterymod_log/
fi

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
        rm -f "$DFOLDER"session/screenstatus.txt
    fi
    echo $(date "+%a %b %d %T %Z %Y") variables resseted >>"$DFOLDER"session/log.txt
    VAR_RESET=1
}

#Session data retrieving
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
        echo $(date "+%a %b %d %T %Z %Y") variables retrieved >>"$DFOLDER"session/log.txt
        VAR_RESET=0
    fi
fi

#Screen status
if [[ -f "$DFOLDER"session/screenstatus.txt ]]
then 
    FINAL_SCREENSTATE=$(cat "$DFOLDER"session/screenstatus.txt)
    echo $(date "+%a %b %d %T %Z %Y") FINAL_SCREENSTATE retreived and is $FINAL_SCREENSTATE >>"$DFOLDER"session/log.txt
else
    FINAL_SCREENSTATE="on"
fi

SCREENSTATUS=$(pmset -g log | grep -E 'turned on|turned off'| grep -A60 "$(date -v-1M '+%Y-%m-%d %H:%M')" | tail -n1 | awk '{print $8}')
#search in pmset log for entries timed 1 minute ago onwards max 60 items

if [[ ! -z "$SCREENSTATUS"  ]] #difference with -n ?
then
    echo $(date "+%a %b %d %T %Z %Y") pmset gave $SCREENSTATUS, final set to this >>"$DFOLDER"session/log.txt
    echo $SCREENSTATUS >"$DFOLDER"session/screenstatus.txt
else
    echo $(date "+%a %b %d %T %Z %Y") pmset gave nothing, final is $FINAL_SCREENSTATE >>"$DFOLDER"session/log.txt
fi

#Screenshot
if [[ "$FINAL_SCREENSTATE" == "on" ]]
then 
    if [[ "$NUMBUH" -eq "10" ]] 
    then
        #Take a screenshot
        SSDATE=$(date '+%Y-%m-%d_%H-%M')
        if [[ $DEBUG -eq 1 ]]
        then
            #/usr/sbin/screencapture -x "$DFOLDER""$SSDATE".png
            osascript -e "display notification \"$SSDATE Logged (test).\" with title \"Batterymod\""
        else
            /usr/sbin/screencapture -x "$DFOLDER""$SSDATE".png
            #osascript -e "display notification \"$SSDATE Logged.\" with title \"Batterymod\""
        fi
        echo $(date "+%a %b %d %T %Z %Y") screenshot "$DFOLDER""$SSDATE".png attempted >>"$DFOLDER"session/log.txt
        FINAL_LOG=$SESSION_NO.$NUMBUH
        NUMBUH=1 && SESSION_NO=$(($SESSION_NO + 1))
        echo $NUMBUH >"$DFOLDER"session/main.txt
        echo $SESSION_NO >>"$DFOLDER"session/main.txt        
        echo $(date "+%a %b %d %T %Z %Y") Reached 10: sessions are $SESSION_NO and units are $NUMBUH  >>"$DFOLDER"session/log.txt
    else
        #keep counting
        FINAL_LOG=$SESSION_NO.$NUMBUH
        NUMBUH=$(($NUMBUH + 1))
        echo $NUMBUH >"$DFOLDER"session/main.txt
        echo $SESSION_NO >>"$DFOLDER"session/main.txt        
        echo $(date "+%a %b %d %T %Z %Y") Counting: sessions are $SESSION_NO and units are $NUMBUH  >>"$DFOLDER"session/log.txt
    fi
else
    #screen off so reset timer
    echo $(date "+%a %b %d %T %Z %Y") total sessions was $SESSION_NO and lost so many units: $NUMBUH  >>"$DFOLDER"session/log.txt
    NUMBUH=0 && SESSION_NO=0
    echo $NUMBUH >"$DFOLDER"session/main.txt
    echo $SESSION_NO >>"$DFOLDER"session/main.txt        
fi
