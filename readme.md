#bugs
1. Instant sleep (closing lid without screenoff) won't detect off, need to implement caffienate or something
2. Below 10% and charging nags till it passes ten
3. Rebooting and on startup, seems to say "dffolder not defined" (when as applescript app)
4. take a toll on energy usage (5 second queries ?) (same as above clause)
5. Sessions only count tally when off

#to do
- grep command redundant possibly and battstatus one can be tweaked to omit unecessary case for 00
- options, disable specific feature without quitting (see 2 above)
- tell when three days haven't been checked or deleted or just cron a shell script to delete older 
	older than a week
- - need to check the various log files, images are stale enough to be deleted
- - move debug log to separate folder, keep human readable outside
- - log the battery less than 10 percent as well
- calculate time etc in a separate human readable report file (log caveats like anything even remotely lesser than ten minutes 
	won't be logged, usable history even after images deleted)
- minimise irritating screenshot notifications
