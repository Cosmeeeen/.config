#!/usr/bin/env bash
# Tailscale status, icon-only: shield (connected) / dim shield-off (down). Hidden if no CLI.
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

TS="/usr/local/bin/tailscale"
[ -x "$TS" ] || TS="$(command -v tailscale 2>/dev/null)"
[ -z "$TS" ] && { sketchybar --set "$NAME" drawing=off; exit 0; }

state="$("$TS" status --json 2>/dev/null | /usr/bin/jq -r '.BackendState // empty' 2>/dev/null)"

if [ "$state" = "Running" ]; then
  sketchybar --set "$NAME" drawing=on icon="$ICON_VPN" icon.color="$FG4"
elif [ -n "$state" ]; then
  sketchybar --set "$NAME" drawing=on icon="$ICON_VPN_OFF" icon.color="$GRAY"
else
  sketchybar --set "$NAME" drawing=off
fi
