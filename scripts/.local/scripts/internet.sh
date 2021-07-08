#!/bin/bash

# Show wifi  and percent strength or 📡 if none.
# Show 🌐 if connected to ethernet or ❎ if none.
# Show 🔒 if a vpn connection is active

case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
	down) wifiicon="" ;;
	up) wifiicon="$(awk '/^\s*w/ { print "", int($3 * 100 / 70) "% " }' /proc/net/wireless)" ;;
esac

printf "%s%s%s\n" "$wifiicon"
# ethernet and vpn not needed
#"$(sed "s/down/❎/;s/up/🌐/" /sys/class/net/e*/operstate 2>/dev/null)" "$(sed "s/.*/🔒/" /sys/class/net/tun*/operstate 2>/dev/null)"
