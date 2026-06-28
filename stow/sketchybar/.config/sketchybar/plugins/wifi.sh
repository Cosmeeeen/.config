#!/usr/bin/env bash
# Icon-only network indicator: shows whichever connection is the current default
# route (Wi-Fi vs Ethernet), or off. SSID is omitted — macOS 26 redacts it even
# from root, so the name is unavailable.
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

WIFI_DEV="$(networksetup -listallhardwareports 2>/dev/null | awk '/Hardware Port: Wi-Fi/{getline; print $2}')"
PRIMARY="$(route -n get default 2>/dev/null | awk '/interface:/{print $2; exit}')"

if [ -z "$PRIMARY" ]; then
  sketchybar --set "$NAME" icon="$ICON_NET_OFF" icon.color=$GRAY
elif [ "$PRIMARY" = "$WIFI_DEV" ]; then
  sketchybar --set "$NAME" icon="$ICON_WIFI" icon.color=$GREEN
else
  sketchybar --set "$NAME" icon="$ICON_ETHERNET" icon.color=$GREEN
fi
