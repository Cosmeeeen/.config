#!/usr/bin/env bash
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

PERCENT="$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep -c 'AC Power')"
[ -z "$PERCENT" ] && exit 0

case "$PERCENT" in
  100|9[0-9]) ICON="$ICON_BAT_FULL" ;;
  [7-8][0-9]) ICON="$ICON_BAT_80" ;;
  [5-6][0-9]) ICON="$ICON_BAT_60" ;;
  [3-4][0-9]) ICON="$ICON_BAT_40" ;;
  [1-2][0-9]) ICON="$ICON_BAT_20" ;;
  *)          ICON="$ICON_BAT_EMPTY" ;;
esac

if [ "$PERCENT" -le 20 ]; then COLOR=$RED
elif [ "$PERCENT" -le 40 ]; then COLOR=$YELLOW
else COLOR=$GREEN
fi

if [ "$CHARGING" -ne 0 ]; then
  ICON="$ICON_BAT_CHG"; COLOR=$GREEN
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${PERCENT}%"
