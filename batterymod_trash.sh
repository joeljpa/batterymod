#!/bin/bash
IMG_TOTAL=$(ls -lt | grep .png | wc -l)
IMG_READY=$((($IMG_TOTAL * 3) / 4))
ls -t | grep .png | tail -n $IMG_READY | xargs du -ch
#ls -t | grep .png | tail -n $IMG_READY | xargs rmtrash
