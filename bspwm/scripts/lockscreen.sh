#!/bin/bash

WALLPAPER="$HOME/.config/bspwm/1000001967.jpg"
[ ! -f "$WALLPAPER" ] && WALLPAPER="$HOME/Pictures/wallpapers/wallpaper.jpg"

CACHE_DIR="/tmp/lockscreen"
mkdir -p "$CACHE_DIR"

# Get all active geometries
GEOMS=$(xrandr --query | grep -w "connected" | grep -o -E "[0-9]+x[0-9]+\+[0-9]+\+[0-9]+")

# If no active geometries (failsafe), fallback to single screen
if [ -z "$GEOMS" ]; then
    GEOMS="1366x768+0+0"
fi

# Calculate hashes for caching
GEOM_HASH=$(echo "$GEOMS" | md5sum | cut -d' ' -f1)
WP_HASH=$(stat -c %Y "$WALLPAPER" 2>/dev/null || echo "0")
CACHE="$CACHE_DIR/lock-${GEOM_HASH}-${WP_HASH}.png"

# Generate combined blurred image if it doesn't exist
if [ ! -f "$CACHE" ]; then
    TOTAL_W=0
    TOTAL_H=0
    for geom in $GEOMS; do
        W=$(echo $geom | cut -d'x' -f1)
        rest=$(echo $geom | cut -d'x' -f2)
        H=$(echo $rest | cut -d'+' -f1)
        X=$(echo $rest | cut -d'+' -f2)
        Y=$(echo $rest | cut -d'+' -f3)
        
        RIGHT=$((X + W))
        BOTTOM=$((Y + H))
        
        [ $RIGHT -gt $TOTAL_W ] && TOTAL_W=$RIGHT
        [ $BOTTOM -gt $TOTAL_H ] && TOTAL_H=$BOTTOM
    done
    
    # Build magick command
    CMD="magick -size ${TOTAL_W}x${TOTAL_H} xc:#0a0a0f"
    for geom in $GEOMS; do
        W=$(echo $geom | cut -d'x' -f1)
        rest=$(echo $geom | cut -d'x' -f2)
        H=$(echo $rest | cut -d'+' -f1)
        X=$(echo $rest | cut -d'+' -f2)
        Y=$(echo $rest | cut -d'+' -f3)
        
        CMD="$CMD \( \"$WALLPAPER\" -resize ${W}x${H}^ -gravity center -extent ${W}x${H} -blur 0x8 \) -geometry +${X}+${Y} -composite"
    done
    CMD="$CMD \"$CACHE\""
    eval "$CMD"
fi

# Find primary monitor to position the clock/text
PRIMARY_GEOM=$(xrandr --query | grep -w "primary" | grep -o -E "[0-9]+x[0-9]+\+[0-9]+\+[0-9]+")
if [ -z "$PRIMARY_GEOM" ]; then
    # Fallback to the first active screen
    PRIMARY_GEOM=$(echo "$GEOMS" | head -n 1)
fi

PW=$(echo $PRIMARY_GEOM | cut -d'x' -f1)
prest=$(echo $PRIMARY_GEOM | cut -d'x' -f2)
PH=$(echo $prest | cut -d'+' -f1)
PX=$(echo $prest | cut -d'+' -f2)
PY=$(echo $prest | cut -d'+' -f3)

X_POS=$((PX + PW - 70))
Y_TIME=$((PY + 220))
Y_DATE=$((PY + 100))
Y_TEXT=$((PY + 290))

# Visual Palette (Hex: RRGGBBAA)
CYAN_SOLID="00f0ffff"
RED_SOLID="ff5555ff"
ALPHA_ZERO="00000000"

# Lock the screen with stable, valid i3lock-color arguments
/usr/bin/i3lock \
  --image="$CACHE" \
  --force-clock \
  --time-align=2 --date-align=2 --wrong-align=2 --verif-align=2 \
  --time-str="%H:%M" \
  --time-color=$CYAN_SOLID --time-pos="${X_POS}:${Y_TIME}" --time-size=120 --time-font="Audiowide" \
  --date-str="%A, %B %d" \
  --date-color=ffffffff --date-pos="${X_POS}:${Y_DATE}" --date-size=26 --date-font="Audiowide" \
  --wrong-text="WRONG PASSWORD" \
  --wrong-color=$RED_SOLID --wrong-pos="${X_POS}:${Y_TEXT}" --wrong-size=22 --wrong-font="Audiowide" \
  --verif-text="VERIFYING..." \
  --verif-color=$CYAN_SOLID --verif-pos="${X_POS}:${Y_TEXT}" --verif-size=22 --verif-font="Audiowide" \
  --inside-color=$ALPHA_ZERO \
  --ring-color=$ALPHA_ZERO \
  --line-color=$ALPHA_ZERO \
  --separator-color=$ALPHA_ZERO \
  --insidever-color=$ALPHA_ZERO \
  --ringver-color=$ALPHA_ZERO \
  --insidewrong-color=$ALPHA_ZERO \
  --ringwrong-color=$ALPHA_ZERO \
  --keyhl-color=$ALPHA_ZERO \
  --bshl-color=$ALPHA_ZERO \
  --noinput-text="" --greeter-text="" \
  --radius=10 --ring-width=4 \
  --ignore-empty-password \
  --pass-media-keys --pass-screen-keys --pass-volume-keys
