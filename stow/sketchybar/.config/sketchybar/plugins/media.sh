#!/usr/bin/env bash
# Now-playing via AppleScript (works on macOS 26 where MediaRemote is restricted).
# Queries Music and Spotify only if already running — never launches them.
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

osa() { osascript -e "$1" 2>/dev/null; }

DETAILS=""
for APP in "Music" "Spotify"; do
  [ "$(osa "application \"$APP\" is running")" = "true" ] || continue
  [ "$(osa "tell application \"$APP\" to player state as string")" = "playing" ] || continue
  TRACK="$(osa "tell application \"$APP\" to name of current track")"
  ARTIST="$(osa "tell application \"$APP\" to artist of current track")"
  [ -n "$TRACK" ] && DETAILS="${ARTIST:+$ARTIST – }$TRACK"
  [ -n "$DETAILS" ] && break
done

if [ -n "$DETAILS" ]; then
  [ ${#DETAILS} -gt 40 ] && DETAILS="${DETAILS:0:40}…"
  sketchybar --set "$NAME" drawing=on icon="$ICON_MUSIC" icon.color=$AQUA label="$DETAILS"
else
  sketchybar --set "$NAME" drawing=off
fi
