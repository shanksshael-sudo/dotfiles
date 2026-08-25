#!/bin/bash
if bluetoothctl show | grep -q "Powered: yes"; then
  TOGGLE="󰂲  Disable Bluetooth"
  devices=$(bluetoothctl devices 2>/dev/null | \
    awk '{$1=""; $2=""; print "󰂱 "substr($0,3)}')
  chosen=$(printf "$TOGGLE\n$devices\n󰂴  Scan for devices" | \
    rofi -dmenu -p "󰂯  Bluetooth" \
    -theme ~/.config/rofi/launcher.rasi \
    -theme-str 'window { width: 380px; } listview { lines: 8; }')
else
  chosen=$(printf "󰂯  Enable Bluetooth" | \
    rofi -dmenu -p "󰂯  Bluetooth" \
    -theme ~/.config/rofi/launcher.rasi)
fi

[ -z "$chosen" ] && exit

if echo "$chosen" | grep -q "Enable"; then
  bluetoothctl power on
elif echo "$chosen" | grep -q "Disable"; then
  bluetoothctl power off
elif echo "$chosen" | grep -q "Scan"; then
  dunstify "󰂯" "Scanning for bluetooth devices..."
  bluetoothctl scan on &
  sleep 8 && bluetoothctl scan off
  ~/.config/rofi/scripts/btmenu.sh
fi
