#!/usr/bin/env bash
# Drives all workspace pills: shows only occupied + focused workspaces, highlights the
# focused one, renders the app glyphs in each, and pins each pill to its monitor's bar.
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/helpers/icon_map.sh"

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
NONEMPTY=" $(aerospace list-workspaces --monitor all --empty no 2>/dev/null | tr '\n' ' ') "
ALL="$(aerospace list-workspaces --all)"
# workspace -> monitor-id map (so each pill only shows on its own monitor's bar)
WSMON="$(aerospace list-workspaces --monitor all --format '%{workspace} %{monitor-id}' 2>/dev/null)"

args=()
for sid in $ALL; do
  mon="$(printf '%s\n' "$WSMON" | awk -v s="$sid" '$1==s {print $2; exit}')"
  [ -z "$mon" ] && mon=1

  occupied=0
  case "$NONEMPTY" in *" $sid "*) occupied=1 ;; esac

  appicons=""
  if [ "$occupied" = "1" ]; then
    while IFS= read -r app; do
      [ -z "$app" ] && continue
      __icon_map "$app"
      appicons+="${icon_result}"
    done < <(aerospace list-windows --workspace "$sid" --format '%{app-name}' 2>/dev/null | awk '!seen[$0]++')
  fi

  if [ "$sid" = "$FOCUSED" ]; then
    args+=(--set space.$sid display=$mon drawing=on background.drawing=on \
      background.color=$WS_FOCUS_BG icon.color=$WS_FOCUS_FG \
      label="$appicons" label.color=$WS_FOCUS_FG \
      label.drawing=$([ -n "$appicons" ] && echo on || echo off))
  elif [ "$occupied" = "1" ]; then
    args+=(--set space.$sid display=$mon drawing=on background.drawing=on \
      background.color=$WS_OCC_BG icon.color=$WS_OCC_FG \
      label="$appicons" label.color=$WS_OCC_FG \
      label.drawing=$([ -n "$appicons" ] && echo on || echo off))
  else
    args+=(--set space.$sid display=$mon drawing=off background.drawing=off label.drawing=off)
  fi
done

sketchybar "${args[@]}"
