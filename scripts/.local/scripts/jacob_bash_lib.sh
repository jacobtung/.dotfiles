###############################################################################
#                            Jacob's bash func lib                            #
###############################################################################

# load jacob's debian default background picture
loadbg() {
	feh -z --bg-fill --no-fehbg /home/jacob/Pictures/Backgrounds/linux-debian-wallpaper.jpg
}

# load background picture according the time. day;dusk;midnight
loadbg1() {
	local bgpath=~/Pictures/Backgrounds
	local time=$(date +"%H")

	case $time in
		2[2-3]|0[0-8])
			feh -z --bg-fill --no-fehbg $bgpath/Midnight;;
		09|1[0-5])
			feh -z --bg-fill --no-fehbg $bgpath/Day;;
		1[6-9]|2[0-1])
			feh -z --bg-fill --no-fehbg $bgpath/Dusk;;
	esac
}

#test the point client information title instance ...
showclientinfo() {
	xprop | awk '
		/^WM_CLASS/{sub(/.* =/, "instance:"); sub(/,/, "\nclass:"); print}
		/^WM_NAME/{sub(/.* =/, "title:"); print}'
}

# screenshot
printscreen() {
	import /tmp/latest-screenshot.png
	local sreenshottime=$(date +"%Y-%m-%d-%H:%M:%S")
	if [ -d /home/jacob/Pictures/Screenshots/ ]; then
		mkdir -p /home/jacob/Pictures/Screenshots/
	fi
	cp -n /tmp/latest-screenshot.png /home/jacob/Pictures/Screenshots/screenshot-$sreenshottime.png
}

