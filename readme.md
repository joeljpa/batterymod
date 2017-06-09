#bugs
1. Instant sleep (closing lid without screenoff) won't detect off, need to implement caffienate or something -- mostly resolved, only an issue for applescript
2. Below 10% and charging nags till it passes ten
3. Rebooting and on startup, seems to say "dffolder not defined" (when as applescript app)
4. take a toll on energy usage (5 second queries ?) (same as above clause)
5. Tue Apr 25 21:13:03 IST 2017 variables retrieved
Tue Apr 25 21:13:08 IST 2017 FINAL_SCREENSTATE retreived and is on
Tue Apr 25 21:38:28 IST 2017 pmset gave off, final set to this
Tue Apr 25 21:38:34 IST 2017 screenshot /Users/joel/Desktop/batterymod_log/2017-04-25_21-38.png attempted
Tue Apr 25 21:38:34 IST 2017 Reached 10: sessions are 3 and units are 1
Tue Apr 25 21:39:00 IST 2017 variables retrieved
Tue Apr 25 21:39:00 IST 2017 FINAL_SCREENSTATE retreived and is off
it didn't reset vars, but was probably rm alias so fixed?
Wed May 31 03:58:00 IST 2017 variables retrieved
Wed May 31 03:58:00 IST 2017 FINAL_SCREENSTATE retreived and is on
Wed May 31 03:58:01 IST 2017 pmset gave nothing, final is on
Wed May 31 03:58:01 IST 2017 Counting: sessions are 0 and units are 8
Wed May 31 03:59:00 IST 2017 variables retrieved
Wed May 31 03:59:00 IST 2017 FINAL_SCREENSTATE retreived and is on
Wed May 31 03:59:01 IST 2017 pmset gave nothing, final is on
Wed May 31 03:59:01 IST 2017 Counting: sessions are 0 and units are 9
Wed May 31 04:00:01 IST 2017 variables retrieved
Wed May 31 05:16:45 IST 2017 FINAL_SCREENSTATE retreived and is on
Wed May 31 05:16:47 IST 2017 pmset gave nothing, final is on
Wed May 31 05:16:47 IST 2017 Counting: sessions are 0 and units are 10
Wed May 31 05:17:01 IST 2017 variables retrieved
Wed May 31 05:17:01 IST 2017 FINAL_SCREENSTATE retreived and is on
Wed May 31 05:17:02 IST 2017 pmset gave on, final set to this
Wed May 31 05:17:02 IST 2017 screenshot /Users/joel/Desktop/batterymod_log/2017-05-31_05-17.png attempted
Wed May 31 05:17:02 IST 2017 Reached 10: sessions are 1 and units are 1
Wed May 31 05:18:00 IST 2017 variables retrieved
Wed May 31 05:18:00 IST 2017 FINAL_SCREENSTATE retreived and is on
Wed May 31 05:18:02 IST 2017 pmset gave nothing, final is on
Wed May 31 05:18:02 IST 2017 Counting: sessions are 1 and units are 2



#to do
- grep command redundant possibly and battstatus one can be tweaked to omit unecessary case for 00
- options, disable specific feature without quitting (see 2 above)
- IMP tell when three days haven't been checked or deleted or just cron a shell script to delete older 
	older than a month (for making a full report on it )
- - need to check the various log files, images are stale enough to be deleted
- - move debug log to separate folder, keep human readable outside
- - log the battery less than 10 percent as well
- IMP calculate time etc in a separate human readable report file (log caveats like anything even remotely lesser than ten minutes 
	won't be logged, usable history even after images deleted)
- - format draft: tally each time, complete one for each hour and sum it up for the day    
- - deprecate Awareness's role completely in addition to having more control and options with it; the mouse being idle and resetted needs to be done somehow
- - Sessions only count tally when off, try to mimic Awareness and log that
- minimise irritating screenshot notifications
- - icons can be changed but for that the notification might have to be a separate applescript file with a "bundle"
- check even things like energy load (pmset?), notify when crosses a threshold but make nagging optional
