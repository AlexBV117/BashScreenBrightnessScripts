#!/usr/bin/bash
BRIGHTNESS=$(cat ~/.brightness/brightness.txt)

# checks that an increase will not overdrive the 
# display reducing accidental damage
LIMIT_UPPER=$(echo "$BRIGHTNESS >= 1" | bc);
if [[ $LIMIT_UPPER -eq 1 ]]; then
    BRIGHTNESS=1;
    exit 0;
fi

# changes the new display brightness and persists it
BRIGHTNESS=$(echo "$BRIGHTNESS + 0.05" | bc);
echo $BRIGHTNESS > ~/.brightness/brightness.txt;

# Finds the names of the connected displays and puts them in an array
DISPLAYS=$(xrandr -q | grep -o -E '^([^ ]+) connected' | grep -o -E '^([^ ]+)')
DISPLAY_NAMES=($(echo $DISPLAYS | tr " " "\n"))

# change the display brightness for all connected displays
for i in "${DISPLAY_NAMES[@]}"
do
    xrandr --output "$i" --brightness $BRIGHTNESS
done