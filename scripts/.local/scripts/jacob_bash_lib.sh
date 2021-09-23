###############################################################################
#                            Jacob's bash func lib                            #
###############################################################################

# load background picture according the time. day;dusk;midnight
loadbg() {
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

mirrorscreen() {
    local RESOLUTION=1920x1080
    xrandr --listmonitors | sed -n '1!p' | sed -e 's/\s[0-9].*\s\([a-zA-Z0-9\-]*\)$/\1/g' | xargs -n 1 -- bash -xc 'xrandr --output $0 --mode '$RESOLUTION' --pos 0x0 --rotate normal'
}

changekeyboard() {
    setxkbmap -option caps:none
    xmodmap -e "keycode 66 = Shift_R NoSymbol Shift_R"
}
