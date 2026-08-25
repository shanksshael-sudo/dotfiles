#!/bin/bash
if bluetoothctl show | grep -q "Powered: yes"; then
  connected=$(bluetoothctl info 2>/dev/null | grep "Name:" | head -1 | sed 's/.*Name: //')
  if [ -n "$connected" ]; then
    echo "󰂱 $connected"
  else
    echo "󰂯"
  fi
else
  echo "󰂲"
fi
