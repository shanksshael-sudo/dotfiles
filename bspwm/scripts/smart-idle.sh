#!/bin/bash
# Kill any existing idle daemon
pkill xidlehook 2>/dev/null
pkill xautolock 2>/dev/null

is_fullscreen() {
  # check if any window is fullscreen on current desktop
  WIN=$(bspc query -N -d -n .fullscreen 2>/dev/null)
  [ -n "$WIN" ]
}

lock() {
  is_fullscreen || ~/.config/bspwm/scripts/lockscreen.sh
}

if command -v xidlehook &>/dev/null; then
  xidlehook \
    --not-when-fullscreen \
    --not-when-audio \
    --timer 300 "~/.config/bspwm/scripts/lockscreen.sh" "" \
    --timer 60  "systemctl suspend" "" &
else
  # fallback: xautolock with fullscreen check
  xautolock \
    -time 5 \
    -locker "~/.config/bspwm/scripts/smart-lock.sh" \
    -corners 0000 &
fi

echo $! > /tmp/idle-daemon.pid
