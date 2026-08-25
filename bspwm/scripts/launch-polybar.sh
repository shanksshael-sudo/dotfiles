#!/bin/sh
# Reliable polybar launcher for all connected monitors
# Called from bspwmrc — runs in background

pkill -x polybar
sleep 0.3

# Wait until polybar can see monitors (up to 5s)
for i in $(seq 1 10); do
    count=$(polybar --list-monitors 2>/dev/null | wc -l)
    [ "$count" -ge 1 ] && break
    sleep 0.5
done

for m in $(polybar --list-monitors | cut -d: -f1); do
    MONITOR=$m polybar shanks-left   >> /tmp/polybar-$m.log 2>&1 &
    MONITOR=$m polybar shanks-center >> /tmp/polybar-$m.log 2>&1 &
    MONITOR=$m polybar shanks-right  >> /tmp/polybar-$m.log 2>&1 &
done
