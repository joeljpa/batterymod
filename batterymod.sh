#!/bin/bash

#version 0.41

#Copy this to a separate location for cron to use, so ongoing development won't affect it, note the places labelled "for debug" (redundant, simplify)


DEBUG=0
if [[ $1 -eq 1 ]] 
then
    DEBUG=1
    echo debug enabled
else 
    echo normal mode...
fi

if [[ $DEBUG -eq 1 ]]
then 
    DFOLDER=~/Stuff/Myprojects/batterymod/test/
else
    DFOLDER=~/Desktop/batterymod_log/
fi

mkdir -p $DFOLDER && mkdir -p "$DFOLDER"session 
REPORT=session/report.txt
touch "$DFOLDER$REPORT"

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
    #notify as well?
}

#lastHour () {
#    LAST_HOUR=$(tail -n1 "$DFOLDER"session/log.txt | awk '{print $4}') 
#    LAST_HOUR=$(date -j -f "%H:%M:%S" $LAST_HOUR "+%H")
#    echo LAST_HOUR is $LAST_HOUR
#    CURRENT_HOUR=$(date '+%H')
#    if [[ "$LAST_HOUR" -eq "$CURRENT_HOUR" ]]
#    then
#        echo same hour!
#        IS_LAST_HOUR=1
#    else
#        echo lasthhour not equal, change line
#        IS_LAST_HOUR=0
#        #it still keeps the hours in the template
#    fi
#}

#updateReport () 
#{
#    #if [[ "$VAR_RESET" -eq 0 ]]   
#    #then  #why this? 
#    LAST_HOUR=$(tail -n1 "$DFOLDER"session/log.txt | awk '{print $4}') 
#    LAST_HOUR=$(date -j -f "%H:%M:%S" $LAST_HOUR "+%H")
#    CURRENT_HOUR=$(date '+%H')
#    LAST_DAY=$(tail -n1 "$DFOLDER"session/log.txt | awk '{print $3}') 
#    CHANGE_LOG=1
#    if [[ -f "$DFOLDER$REPORT" ]]
#    then
#        if [[ "$LAST_HOUR" -eq "$CURRENT_HOUR" ]] #IS_LAST_HOUR
#        then
#            LOG_TEMPLATE="$(date) - $(date '+%H'):00 to $(expr $(date '+%H') + 1):00 - $1"
#            LOGNO=$(wc -l < "$DFOLDER$REPORT")
#            CHANGE_LOG=$1
#            if [[ $LOGNO -eq 0 ]] #why? extra third condition?
#            then
#                echo $LOG_TEMPLATE >> "$DFOLDER$REPORT"
#            else
#                sed -i '.tmp' "$(echo $LOGNO)s/.*/$LOG_TEMPLATE/" "$DFOLDER$REPORT"  #this seems to be creating duplicate report.txt with special char at the end...duh -i
#                rm "$DFOLDER"session/report.txt.tmp
#            fi
#            return $CHANGE_LOG #needs to be normal ints
#        else
#            #echo lasthhour not equal, change line
#            CHANGE_LOG=0
#            LOG_TEMPLATE="$(date) - $(date '+%H'):00 to $(expr $(date '+%H') + 1):00 - $CHANGE_LOG"
#            #it still keeps the hours in the template
#            echo $LOG_TEMPLATE >> "$DFOLDER$REPORT"
#            return $CHANGE_LOG #needs to be normal ints
#        fi
#    fi
#    #fi
#}    

#replaceMonthOld ()
#{
#    LOCATIO=$1
#    CURRENT_MONTH=$(date -j -f "%a %b %d %T %Z %Y" "$(date)" “+%b”) date format can be shortened to just echo $(date '+%b')
#    CURRENT_YEAR=$(date -j -f "%a %b %d %T %Z %Y" "$(date)" “+%Y”)
#    CREATED_MONTH=$(ls -lUT $1|awk '{print $6}')
#    CREATED_YEAR=$(ls -lUT $1|awk '{print $9}')
#    if [[ "$CURRENT_YEAR" -eq "$CREATED_YEAR" ]] 
#    then 
#        if [[ "$CURRENT_MONTH" != "$CREATED_MONTH" ]]
#        then
#            return 1
#        else 
#            return 0
#        fi
#    else 
#        return 1
#    fi
#}

#Session data
if [[ ! -f "$DFOLDER"session/main.txt ]]
then
    echo "var doesn't exist"
    variableReset
else
    MOD_DATE=$(ls -lT "$DFOLDER"session/main.txt | awk '{print $6, $7, $8, $9}')
    MOD_DATE=$(date -j -f "%b %d %T %Y" "$MOD_DATE" "+%s")
    compareModDate $MOD_DATE
    if [[ "$COMP_MOD_DATE" -gt "120" ]]
    then
        variableReset
        echo "var was old"
    else
        NUMBUH=$(head -n1 "$DFOLDER"session/main.txt)
        SESSION_NO=$(tail -n1 "$DFOLDER"session/main.txt)
        echo $(date "+%a %b %d %T %Z %Y") variables retrieved >>"$DFOLDER"session/log.txt
        VAR_RESET=0
    fi
fi

#Battery status
#BATTSTATUS=$(pmset -g ps | grep -o  '..%' | sed -e 's/%//g') #quotes removed here, not tested
#LOWBATTERY=10
#if [[ "$BATTSTATUS" -lt "$LOWBATTERY" &&  "$BATTSTATUS" -ne "00" ]]
#then
#    osascript -e "display notification \"Battery power is lower than $LOWBATTERY percent.\" with title \"Batterymod\""
#fi

#Screen status
if [[ -f "$DFOLDER"session/screenstatus.txt ]]
#if [[ -n $SCREENSTATUS ]]
then 
    FINAL_SCREENSTATE=$(cat "$DFOLDER"session/screenstatus.txt)
    echo $(date "+%a %b %d %T %Z %Y") FINAL_SCREENSTATE retreived and is $FINAL_SCREENSTATE >>"$DFOLDER"session/log.txt
else
    FINAL_SCREENSTATE="on"
fi

SCREENSTATUS=$(pmset -g log | grep -E 'turned on|turned off'| grep -A60 "$(date -v-1M '+%Y-%m-%d %H:%M')" | tail -n1 | awk '{print $8}')
#search in pmset log for entries timed 1 minute ago onwards max 60 items

if [[ ! -z "$SCREENSTATUS"  ]]
then
    echo $(date "+%a %b %d %T %Z %Y") pmset gave $SCREENSTATUS, final set to this >>"$DFOLDER"session/log.txt
    echo $SCREENSTATUS >"$DFOLDER"session/screenstatus.txt
else
    echo $(date "+%a %b %d %T %Z %Y") pmset gave nothing, final is $FINAL_SCREENSTATE >>"$DFOLDER"session/log.txt
fi

#Screenshot
if [[ "$FINAL_SCREENSTATE" == "on" ]]
then 
    if [[ "$NUMBUH" -eq "10" ]] #at smaller query-time values, there's an additional second to account for running this itself; 
                                #so a 5 second query would required 100 not 120 for every ten minutes
    then
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
        #updateReport $FINAL_LOG
        NUMBUH=1 && SESSION_NO=$(($SESSION_NO + 1))
        #export BATTERYMOD_LASTACTIVE=$(date -j -f "%a %b %d %T %Z %Y" "$(date)" "+%s")
        echo $NUMBUH >"$DFOLDER"session/main.txt
        echo $SESSION_NO >>"$DFOLDER"session/main.txt        
        echo $(date "+%a %b %d %T %Z %Y") Reached 10: sessions are $SESSION_NO and units are $NUMBUH  >>"$DFOLDER"session/log.txt
        #if hour changed -> change line and reset score
    else
        FINAL_LOG=$SESSION_NO.$NUMBUH
        #updateReport $FINAL_LOG
        NUMBUH=$(($NUMBUH + 1))
        echo $NUMBUH >"$DFOLDER"session/main.txt
        echo $SESSION_NO >>"$DFOLDER"session/main.txt        
        echo $(date "+%a %b %d %T %Z %Y") Counting: sessions are $SESSION_NO and units are $NUMBUH  >>"$DFOLDER"session/log.txt
    fi
else
    echo $(date "+%a %b %d %T %Z %Y") total sessions was $SESSION_NO and lost so many units: $NUMBUH  >>"$DFOLDER"session/log.txt
    #update report
    NUMBUH=0 && SESSION_NO=0
    echo $NUMBUH >"$DFOLDER"session/main.txt
    echo $SESSION_NO >>"$DFOLDER"session/main.txt        
fi
