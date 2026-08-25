#!/bin/bash
WIFI_IF="wlan0"

# check interface is up
if ! ip link show "$WIFI_IF" 2>/dev/null | grep -q "state UP"; then
  echo "󰤭  offline"
  exit 0
fi

# Try nmcli (NetworkManager) - most common and reliable SSID retriever
SSID=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | grep '^yes:' | cut -d':' -f2)

# Fallback 1: use iwgetid (wireless_tools)
if [ -z "$SSID" ]; then
  SSID=$(iwgetid -r "$WIFI_IF" 2>/dev/null)
fi

# Fallback 2: use iwctl (iwd)
if [ -z "$SSID" ]; then
  SSID=$(iwctl station "$WIFI_IF" show 2>/dev/null | \
    awk '/Connected network/{for(i=3;i<=NF;i++) printf "%s%s",$i,(i<NF?" ":"\n")}' | xargs)
fi

# Fallback 3: iw
if [ -z "$SSID" ]; then
  SSID=$(iw dev "$WIFI_IF" link 2>/dev/null | grep "SSID:" | sed 's/^\s*SSID:\s*//')
fi

if [ -n "$SSID" ]; then
  echo "󰤨  $SSID"
else
  echo "󰤭  offline"
fi
