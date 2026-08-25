#!/bin/bash

# === YOUR CUSTOM FILES ===
# Set paths to your images
WALLPAPER="$HOME/Pictures/wallpaper.jpg"
FACE="$HOME/.face.png"
CACHE="/tmp/mac-lock-bg.png"

# === Aesthetic Settings ===
FONT_CLOCK="Oswald Bold"    # Main thick time font
FONT_SUB="Oswald"           # Lighter font for date/username
BLUR="0x20"                 # Heaviness of blur (0x10 is lighter)

# 1. Detect Screen Resolution (Crucial for fixing 'Zoom' bug)
SCREEN=$(xrandr --current | grep '*' | uniq | awk '{print $1}')
echo ">>> Detected screen resolution: $SCREEN"

# 2. Check for missing assets before generation
if [ ! -f "$WALLPAPER" ]; then
    echo ">>> ERROR: $WALLPAPER not found. Lockscreen will have a dark gray fallback."
    WALLPAPER_SOURCE="canvas:#222222"
else
    WALLPAPER_SOURCE="$WALLPAPER"
fi

# 3. Generate the background in the CACHE
echo ">>> Generating minimalist background..."

# Command sequence:
# Load image -> Resize/Crop to fit screen (FIXES ZOOM) -> Apply Blur
magick "$WALLPAPER_SOURCE" \
       -resize "$SCREEN^" -gravity center -crop "$SCREEN+0+0" +repage \
       -blur "$BLUR" \
       "$CACHE"

# 4. Composite the avatar (FACE) only if it exists
if [ -f "$FACE" ]; then
    echo ">>> Face found! Stamping profile picture onto background..."
    
    # We create a 120x120 circle-cropped version of your face and stamp it in the center (+0+0 geometry)
    magick "$CACHE" \
           \( "$FACE" -resize 120x120^ -gravity center -extent 120x120 -gravity center \
              \( -size 120x120 xc:black -fill white -draw "circle 60,60 60,119" \) \
              -alpha off -compose CopyOpacity -composite \
           \) \
           -gravity center -geometry +0+0 -composite \
           "$CACHE"
else
    echo ">>> Face NOT found at $FACE. Skipping avatar stamp."
fi

# 5. Launch i3lock with the corrected TrueType Font (Oswald)
echo ">>> Locking screen..."
i3lock \
  --image="$CACHE" \
  --indicator \
  --radius=30 --ring-width=3 \
  --inside-color=00000000 --ring-color=00000000 \
  --insidever-color=00000000 --ringver-color=ffffff55 \
  --insidewrong-color=00000000 --ringwrong-color=ff555588 \
  --keyhl-color=ffffffff --bshl-color=ff555588 \
  --line-uses-inside \
  --separator-color=00000000 \
  --clock \
  --time-str="%H:%M" \
  --time-color=ffffffff --time-pos="w/2:h/2-140" --time-size=125 --time-font="$FONT_CLOCK" \
  --date-str="%A, %B %d" \
  --date-color=ffffffcc --date-pos="w/2:h/2-240" --date-size=24 --date-font="$FONT_SUB" \
  --greeter-text="$USER" \
  --greeter-color=ffffffff --greeter-pos="w/2:h/2+90" --greeter-size=22 --greeter-font="$FONT_SUB" \
  --verif-text="" --wrong-text="" --noinput-text="" \
  --ind-pos="w/2:h/2+150" \
  --ignore-empty-password \
  --pass-media-keys --pass-screen-keys --pass-volume-keys
