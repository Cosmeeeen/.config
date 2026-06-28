#!/usr/bin/env bash
# Sets up a tmux session with 3 windows: claude, nvim, zsh.
# Usage: tmux-claude [session-name]
# Session name defaults to the basename of the current directory.

set -euo pipefail

dir="$PWD"
name="${1:-$(basename "$dir")}"
# tmux dislikes . and : in session names
name="${name//./_}"
name="${name//:/_}"

if tmux has-session -t="$name" 2>/dev/null; then
    echo "Session '$name' already exists." >&2
else
    tmux new-session -d -s "$name" -c "$dir" -n claude
    tmux send-keys -t "$name:claude" "claude" C-m
    tmux new-window -t "$name:" -c "$dir" -n nvim
    tmux send-keys -t "$name:nvim" "nvim ." C-m
    tmux new-window -t "$name:" -c "$dir" -n zsh
    tmux select-window -t "$name:claude"
fi

if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$name"
else
    tmux attach -t "$name"
fi
