#!/bin/bash
DEVICE="wlan0"

# get current connection
SSID=$(iw dev "$DEVICE" link 2>/dev/null | grep "SSID:" | awk '{print $2}')
[ -z "$SSID" ] && SSID=$(iwctl station "$DEVICE" show 2>/dev/null | \
  awk '/Connected network/{for(i=3;i<=NF;i++) printf "%s%s",$i,(i<NF?" ":"\n")}')

# scan
iwctl station "$DEVICE" scan 2>/dev/null
sleep 1.5

# get networks
NETWORKS=$(iwctl station "$DEVICE" get-networks 2>/dev/null | \
  tail -n +5 | \
  grep -v "^[[:space:]]*$\|\-\-\-\|>" | \
  while IFS= read -r line; do
    # trim leading spaces
    trimmed=$(echo "$line" | sed 's/^[[:space:]]*//')
    [ -z "$trimmed" ] && continue
    # network name is everything before the security type
    name=$(echo "$trimmed" | awk '{
      for(i=1;i<=NF;i++){
        if($i=="psk"||$i=="open"||$i=="8021x") break
        printf "%s%s",$i,(i<NF?" ":"")
      }
    }')
    [ -n "$name" ] && echo "󰤨  $name"
  done | head -15)

# header message
if [ -n "$SSID" ]; then
  MSG="Connected: $SSID"
  TOGGLE="󰤭  Disconnect"
else
  MSG="Not connected"
  TOGGLE=""
fi

CHOICE=$(printf "$TOGGLE\n$NETWORKS" | grep -v "^$" | \
  rofi -dmenu \
  -p "  WiFi" \
  -mesg "$MSG" \
  -theme ~/.config/rofi/launcher.rasi \
  -theme-str 'window { width: 460px; } listview { lines: 12; }')

[ -z "$CHOICE" ] && exit 0

if echo "$CHOICE" | grep -q "Disconnect"; then
  iwctl station "$DEVICE" disconnect
  notify-send "󰤭" "WiFi disconnected"
  exit 0
fi

# get clean SSID from choice
TARGET=$(echo "$CHOICE" | sed 's/^󰤨  //' | sed 's/[[:space:]]*$//')
[ -z "$TARGET" ] && exit 0

# check if known network
KNOWN=$(iwctl known-networks list 2>/dev/null | grep -F "$TARGET")

if [ -n "$KNOWN" ]; then
  iwctl station "$DEVICE" connect "$TARGET" 2>/dev/null
  notify-send "󰤨" "Connecting to $TARGET..."
else
  PASS=$(rofi -dmenu \
    -p "󰌋  Password" \
    -mesg "Enter password for: $TARGET" \
    -password \
    -theme ~/.config/rofi/launcher.rasi)
  [ -z "$PASS" ] && exit 0
  iwctl --passphrase="$PASS" station "$DEVICE" connect "$TARGET" 2>/dev/null
  notify-send "󰤨" "Connecting to $TARGET..."
fi
