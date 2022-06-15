#!/usr/bin/bash
BRIGHTNESS=$(cat ~/.brightness/brightness.txt)

# checks stop decreasing the brightness at 0
LIMIT_LOWER=$(echo "$BRIGHTNESS <= 0" | bc);
if [[ $LIMIT_LOWER -eq 1 ]]; then
    BRIGHTNESS=0;
    exit 0;
fi

# Decreases the brightness level and persists it
BRIGHTNESS=$(echo "$BRIGHTNESS - 0.05" | bc);
echo $BRIGHTNESS > ~/.brightness/brightness.txt;

# Finds the names of the connected displays and puts them in an array
DISPLAYS=$(xrandr -q | grep -o -E '^([^ ]+) connected' | grep -o -E '^([^ ]+)')
DISPLAY_NAMES=($(echo $DISPLAYS | tr " " "\n"))

# change the display brightness for all connected displays
for i in "${DISPLAY_NAMES[@]}"
do
    xrandr --output "$i" --brightness $BRIGHTNESS
done