#!/usr/bin/env bash
# Aggregates Claude Code session state (written by ~/.claude/hooks/sketchybar-claude/state.sh).
# State reads from the ICON, muted gruvbox tones, NO animation:
#   needs-input (bell)  gruvbox red   >  done (check)  tan, auto-hides   >  working (robot)  dim gray
CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"
DIR="$HOME/.claude/sketchybar-state"
DONE_TTL=10   # seconds the "done" check lingers, then it just disappears

now=$(date +%s)
waiting=0; working=0; finished=0
if [ -d "$DIR" ]; then
  find "$DIR" -type f -mmin +720 -delete 2>/dev/null   # prune stale sessions
  for f in "$DIR"/*; do
    [ -e "$f" ] || continue
    case "$(cat "$f" 2>/dev/null)" in
      waiting) waiting=$((waiting+1)) ;;
      working) working=$((working+1)) ;;
      done)
        mt=$(stat -f %m "$f" 2>/dev/null || echo 0)
        [ $((now - mt)) -le "$DONE_TTL" ] && finished=$((finished+1))
        ;;
    esac
  done
fi

if   [ "$waiting"  -gt 0 ]; then icon="$ICON_CLAUDE_WAIT"; color="$RED";  n=$waiting
elif [ "$finished" -gt 0 ]; then icon="$ICON_CLAUDE_DONE"; color="$FG4";  n=$finished
elif [ "$working"  -gt 0 ]; then icon="$ICON_CLAUDE_WORK"; color="$GRAY"; n=$working
else sketchybar --set "$NAME" drawing=off; exit 0
fi

sketchybar --set "$NAME" drawing=on icon="$icon" icon.color="$color" \
  label="$n" label.color="$color" label.drawing=$([ "$n" -gt 1 ] && echo on || echo off)
exit 0
