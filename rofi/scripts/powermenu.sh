#!/bin/bash
LOCK="󰌾  Lock"
SLEEP="󰒲  Sleep"
RESTART="󰑓  Restart"
SHUTDOWN="󰐥  Shutdown"

chosen=$(printf "$LOCK\n$SLEEP\n$RESTART\n$SHUTDOWN" | \
  rofi -dmenu -p "  Power" \
  -theme ~/.config/rofi/powermenu.rasi 2>/dev/null || \
  printf "$LOCK\n$SLEEP\n$RESTART\n$SHUTDOWN" | \
  rofi -dmenu -p "  Power" \
  -theme ~/.config/rofi/launcher.rasi)

case "$chosen" in
  "$LOCK")     ~/.config/bspwm/lock.sh ;;
  "$SLEEP")    ~/.config/bspwm/lock.sh && systemctl suspend ;;
  "$RESTART")  systemctl reboot ;;
  "$SHUTDOWN") systemctl poweroff ;;
esac
