#!/bin/bash
# looad background picture according the time. day;dusk;midnight
bgpath=~/Pictures/Backgrounds


time=$(date +"%H")

case $time in
	2[2-3]|0[0-8])
		feh -z --bg-fill --no-fehbg $bgpath/Midnight;;
	09|1[0-5])
		feh -z --bg-fill --no-fehbg $bgpath/Day;;
	1[6-9]|2[0-1])
		feh -z --bg-fill --no-fehbg $bgpath/Dusk;;
esac