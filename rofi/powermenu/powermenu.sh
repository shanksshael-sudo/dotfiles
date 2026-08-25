#!/usr/bin/env bash
# Cyan-Black power menu with grey SVG icons
dir="$HOME/.config/rofi/powermenu"
theme="$dir/powermenu-cyan.rasi"
icons="$dir/icons"

lock=" Lock\0icon\x1f$icons/lock.svg"
suspend=" Suspend\0icon\x1f$icons/suspend.svg"
logout=" Logout\0icon\x1f$icons/logout.svg"
reboot=" Reboot\0icon\x1f$icons/reboot.svg"
shutdown=" Shutdown\0icon\x1f$icons/shutdown.svg"

chosen=$(printf '%b\n%b\n%b\n%b\n%b\n' \
    "$lock" "$suspend" "$logout" "$reboot" "$shutdown" \
    | rofi -dmenu -show-icons -theme "$theme" -p "System")

case "$chosen" in
    *Lock*)
        i3lock -c 000000 2>/dev/null \
            || betterlockscreen -l 2>/dev/null \
            || slock &
        ;;
    *Suspend*)   systemctl suspend ;;
    *Logout*)    bspc quit ;;
    *Reboot*)    systemctl reboot ;;
    *Shutdown*)  systemctl poweroff ;;
esac
