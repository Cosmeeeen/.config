#!/usr/bin/env bash
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Second sample = instantaneous usage over ~1s (first sample is since boot).
CPU="$(top -l 2 -n 0 | awk '/CPU usage/ { idle=$7; sub(/%/,"",idle) } END { printf "%.0f", 100-idle }')"
[ -z "$CPU" ] && CPU=0

if [ "$CPU" -ge 80 ]; then COLOR=$RED
elif [ "$CPU" -ge 50 ]; then COLOR=$YELLOW
else COLOR=$FG
fi

sketchybar --set "$NAME" icon="$ICON_CPU" icon.color=$COLOR label="${CPU}%"
