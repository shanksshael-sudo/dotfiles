#!/bin/bash
WIN=$(bspc query -N -d -n .fullscreen 2>/dev/null)
if [ -z "$WIN" ]; then
  ~/.config/bspwm/scripts/lockscreen.sh
fi
