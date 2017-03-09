#bugs
1. Instant sleep (closing lid without screenoff) won't detect off, need to implement caffienate or something
2. Below 10% and charging nags till it passes ten
3. Rebooting and on startup, seems to say "dffolder not defined"

#features
- grep command redundant possibly and battstatus one can be tweaked to omit unecessary case for 00
- options, disable specific feature without quitting
- tell when three days haven't been checked or deleted or just cron a shell script to delete older 
	older than a week
- calculate time etc in a human readable report file (log caveats like anything even remotely lesser than ten minutes 
	won't be logged, usable history even after images deleted)
- log battery less than 10 percent as well
