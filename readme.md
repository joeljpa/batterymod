## Batterymod - a simple bash script which logs your activity periodically on OS X

#### Introduction
Batterymod works by checking the whether the screen is on via OS X's pmset command. So it's possible for it to work on other *Unixes provided an equivalent command to pmset replaces it. To use batterymod, it must be scheduled to run by cron every minute. By default, every ten minutes a screenshot is taken capturing your work - provided your screen was on throughout that time.
