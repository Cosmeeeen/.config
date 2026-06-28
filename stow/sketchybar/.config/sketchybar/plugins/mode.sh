#!/usr/bin/env bash
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

MODE="$(aerospace list-modes --current 2>/dev/null)"

if [ -z "$MODE" ] || [ "$MODE" = "main" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on icon="$ICON_COG" icon.color=$RED \
    label="$(echo "$MODE" | tr '[:lower:]' '[:upper:]')"
fi
