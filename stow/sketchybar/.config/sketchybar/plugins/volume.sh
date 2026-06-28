#!/usr/bin/env bash
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
fi
MUTED="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)"

if [ "$MUTED" = "true" ] || [ "$VOLUME" = "0" ]; then
  ICON="$ICON_VOL_MUTE"; COLOR=$GRAY
else
  case "$VOLUME" in
    [6-9][0-9]|100)   ICON="$ICON_VOL_HI" ;;
    [3-5][0-9])       ICON="$ICON_VOL_MID" ;;
    [1-9]|[1-2][0-9]) ICON="$ICON_VOL_LO" ;;
    *)                ICON="$ICON_VOL_MUTE" ;;
  esac
  COLOR=$FG
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${VOLUME}%"
