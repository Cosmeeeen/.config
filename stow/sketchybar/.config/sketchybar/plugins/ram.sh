#!/usr/bin/env bash
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

FREE="$(memory_pressure 2>/dev/null | awk -F: '/System-wide memory free percentage/ {gsub(/[ %]/,"",$2); print $2}')"
[ -z "$FREE" ] && FREE=0
USED=$((100 - FREE))

if [ "$USED" -ge 85 ]; then COLOR=$RED
elif [ "$USED" -ge 65 ]; then COLOR=$YELLOW
else COLOR=$FG
fi

sketchybar --set "$NAME" icon="$ICON_RAM" icon.color=$COLOR label="${USED}%"
