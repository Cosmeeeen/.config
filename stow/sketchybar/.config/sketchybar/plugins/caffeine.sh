#!/usr/bin/env bash
# Coffee icon shows only while caffeinate (CLI) or Amphetamine is preventing the
# DISPLAY from sleeping — i.e. actively keeping the *screen* awake. Background
# system-sleep blockers (downloads, some apps, `caffeinate -i`) do NOT count.
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

if pmset -g assertions 2>/dev/null \
     | grep -iE 'PreventUserIdleDisplaySleep' \
     | grep -qiE 'caffeinate|amphetamine'; then
  sketchybar --set "$NAME" drawing=on icon="$ICON_CAFFEINE" icon.color=$ORANGE
else
  sketchybar --set "$NAME" drawing=off
fi
