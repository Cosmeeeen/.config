#!/usr/bin/env bash
# macOS system tweaks for the rice. Idempotent; safe to re-run.
# Some keys need a logout/login (or restart) to fully apply — noted inline.
set -uo pipefail

say() { printf '  • %s\n' "$1"; }
echo "Applying macOS defaults…"

# ── Appearance: Dark + Yellow accent (closest match to gruvbox) ──
defaults write -g AppleInterfaceStyle -string "Dark";                                say "Dark mode"
defaults write -g AppleAccentColor -int 2;                                           say "Accent = Yellow (logout to apply everywhere)"
defaults write -g AppleHighlightColor -string "1.000000 0.937255 0.690196 Yellow";   say "Selection highlight = Yellow"
# NOTE: do NOT enable Reduce Transparency — it kills the translucent bar/terminal.

# ── Menu bar: hide it so SketchyBar owns the top strip ──
defaults write -g _HIHideMenuBar -bool true;                                         say "Hide menu bar"

# ── Desktop: no icons, no widgets, Stage Manager off ──
defaults write com.apple.finder CreateDesktop -bool false;                           say "Hide desktop icons"
defaults write com.apple.WindowManager StandardHideWidgets -int 1;                   say "Hide desktop widgets"
defaults write com.apple.WindowManager GloballyEnabled -bool false;                  say "Stage Manager off"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false; say "Click-wallpaper-to-show-desktop off"

# ── Apply (relaunch the affected agents) ──
killall Finder 2>/dev/null || true
killall WindowManager 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "Done. Log out/in for the accent color + menu-bar changes to fully take effect."
