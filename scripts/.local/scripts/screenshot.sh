#!/bin/bash
# lockscreen scripts cause of i3 exec not good
import /tmp/latest-screenshot.png
sreenshottime=$(date +"%Y-%m-%d-%H:%M:%S")
cp -n /tmp/latest-screenshot.png /home/jacob/Pictures/Screenshots/screenshot-$sreenshottime.png
