#!/usr/bin/bash
#
# Gets the "current" brightness level
BRIGHTNESS=$(cat ./brightness.txt);

# Checks if the brightness is within the allowed range [0 to 1]
# use of bc tool as brightness level is a floating point
LIMIT_UPPER=$(echo "$BRIGHTNESS > 1" | bc);
LIMIT_LOWER=$(echo "$BRIGHTNESS < 0" | bc);
if [[ $LIMIT_UPPER -eq 1 ]]; then
    BRIGHTNESS=1;
fi
if [[ $LIMIT_LOWER -eq 1 ]]; then
    BRIGHTNESS=0;
fi
if [[ $# == 1 ]]; then
    BRIGHTNESS=$1;
fi

# Persists the brightness level
echo $BRIGHTNESS > ./brightness.txt;

# Finds the names of the connected displays and puts them in an array
DISPLAYS=$(xrandr -q | grep -o -E '^([^ ]+) connected' | grep -o -E '^([^ ]+)');
DISPLAY_NAMES=($(echo $DISPLAYS | tr " " "\n"));

# change the display brightness for all connected displays
for i in "${DISPLAY_NAMES[@]}"
do
    xrandr --output "$i" --brightness $BRIGHTNESS
done