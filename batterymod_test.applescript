property lowBattery : 10
global n, dFolder, i, finalScreenState, numbuh
set dFolder to "~/Stuff/Myprojects/batterymod/test/" #			for test use only
set numbuh to 0
set finalScreenState to "on"

repeat 100 times
	
	#battery status
	set battStatus to (do shell script "pmset -g ps | grep -o  '..%' | sed -e 's/%//g'")
	if (battStatus < lowBattery) and (battStatus is not equal to "00") then
		display notification "Battery power is lower than " & lowBattery & " percent."
	end if
	
	#screen status
	do shell script ("mkdir -p " & dFolder)
	set screenState to (do shell script "pmset -g log | grep -E 'turned on|turned off' | grep  -A60 \"$(date -v-1M '+%Y-%m-%d %H:%M';)\" | tail -n1 | awk '{print $8}'") as text
	if (screenState is not equal to "") then
		do shell script ("echo \"$(date)\" pmset gave " & screenState & " >>" & dFolder & "log.txt")
	else
		do shell script ("echo \"$(date)\" pmset gave nothing" & " >>" & dFolder & "log.txt")
	end if
	if (screenState contains "on") or (screenState contains "off") then
		set finalScreenState to screenState
		do shell script ("echo \"$(date)\" contained on/off " & finalScreenState & ">>" & dFolder & "log.txt")
	else
		do shell script ("echo \"$(date)\" moved along " & finalScreenState & ">>" & dFolder & "log.txt")
	end if
	do shell script ("echo \"$(date)\" final " & finalScreenState & ">>" & dFolder & "log.txt")
	
	#screen shot
	if (finalScreenState contains "on") then
		if (numbuh is equal to 10) then
			set ssdate to (do shell script "date '+%Y-%m-%d_%H-%M'")
			do shell script ("/usr/sbin/screencapture " & dFolder & ssdate & ".png")
			do shell script ("echo \"$(date)\" screenshot attempted" & ">>" & dFolder & "log.txt")
			#add session to records
			display notification "Logged."
			set numbuh to 1
		else
			set numbuh to numbuh + 1
		end if
	else
		#tally the completed session
		set numbuh to 0
	end if
	
	delay 5
end repeat