#!/usr/bin/env bash
# ── Theme switcher — SCAFFOLD ──────────────────────────────────────────────────
# STATUS: structural skeleton only ("structure now, switch later"). It loads a
# palette and maps out where each tool's colors would be rewritten. The per-tool
# rewrites are deliberately TODO — gruvbox is currently baked into each config,
# and this lays the groundwork so a second theme is a drop-in later.
#
# Usage (once the TODOs are implemented):  ./lib/apply-theme.sh gruvbox
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME="${1:-gruvbox}"
PAL="$REPO/themes/$THEME.sh"
[ -f "$PAL" ] || { echo "no such theme: '$THEME' (see $REPO/themes/)"; exit 1; }
# shellcheck source=/dev/null
source "$PAL"
echo "Loaded palette: ${THEME_NAME:-$THEME}"

# Each function should rewrite that tool's color file from the $HEX_*/$ARGB_* vars
# (use hex_to_sgr for fastfetch's SGR fields), then reload the app.

apply_sketchybar() {
  # stow/sketchybar/.config/sketchybar/colors.sh  (0xAARRGGBB)  -> then: sketchybar --reload
  return 0
}
apply_borders() {
  # ~/.aerospace.toml after-startup: borders active_color=$ARGB_ACCENT inactive_color=$ARGB_INACTIVE
  return 0
}
apply_ghostty() {
  # stow/ghostty/.config/ghostty/config: theme/background ($HEX_BG0_HARD)  -> restart ghostty
  return 0
}
apply_btop() {
  # stow/btop/.config/btop/btop.conf: color_theme
  return 0
}
apply_starship() {
  # stow/starship/.config/starship.toml: [palettes.*] ($HEX_*)
  return 0
}
apply_fastfetch() {
  # stow/fastfetch/.config/fastfetch/config.jsonc: keyColors/logo ($HEX_*) + display.color (hex_to_sgr)
  return 0
}
apply_fzf() {
  # FZF_DEFAULT_OPTS --color in a sourced colors file ($HEX_*)
  return 0
}
apply_bat()    { :; }   # BAT_THEME — needs a matching bat theme per palette
apply_delta()  { :; }   # stow/home/.gitconfig: [delta] syntax-theme
apply_lazygit(){ :; }   # stow/lazygit/.config/lazygit/config.yml: gui.theme ($HEX_*)

for fn in apply_sketchybar apply_borders apply_ghostty apply_btop apply_starship \
          apply_fastfetch apply_fzf apply_bat apply_delta apply_lazygit; do
  "$fn"
done

echo "Palette is ready. Per-tool rewrites are TODO (see comments) — not switching yet."
