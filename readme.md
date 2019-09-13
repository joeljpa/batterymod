## Batterymod - a simple bash script which logs your activity periodically on OS X

#### Introduction
Find yourself not focusing on work when on your computer? Then is bash script is for you. Every ten minutes a screenshot is taken capturing your work, thus helping one review their screen activity. It helps one catch themselves in case they were slacking off, watching youtube or something, instead of working. It is slightly "smart" in terms of detecting activity...if your screen was "on" mostly uninterrupted for ten minutes (default) it takes a screenshot else it resets its timer.

Batterymod works by checking whether the screen is on via OS X's `pmset` command. So it's possible for it to work on other Unixes, provided an equivalent commands for pmset and take screenshot replace it. To use batterymod, it must be scheduled to run by cron every minute.
