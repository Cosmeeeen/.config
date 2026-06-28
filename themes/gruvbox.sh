#!/usr/bin/env bash
# ── Gruvbox — single source of truth for the rice's palette ────────────────────
# Every themed tool (sketchybar, ghostty, btop, starship, fastfetch, fzf, bat,
# delta, lazygit) currently EMBEDS these values in its own config. The future
# lib/apply-theme.sh regenerates each tool's color file from this one place.
# To add a theme, copy this file (e.g. themes/nord.sh) and change the values.
#
# Tools disagree on color format, so each color is exported in the forms needed:
#   HEX_*  = #rrggbb      (ghostty, starship, fzf, fastfetch keys, lazygit)
#   ARGB_* = 0xaarrggbb   (sketchybar / borders)
#   SGR via hex_to_sgr()  = 38;2;r;g;b  (fastfetch display.color / ANSI truecolor)

THEME_NAME="gruvbox-dark-hard"

# base tones
HEX_BG0_HARD="#1d2021"; ARGB_BG0_HARD="0xff1d2021"   # ghostty background
HEX_BG0="#282828";      ARGB_BG0="0xff282828"
HEX_BG1="#3c3836";      ARGB_BG1="0xff3c3836"         # pill background
HEX_BG2="#504945";      ARGB_BG2="0xff504945"
HEX_BG3="#665c54";      ARGB_BG3="0xff665c54"
HEX_FG="#ebdbb2";       ARGB_FG="0xffebdbb2"          # cream — THE anchor accent
HEX_FG4="#a89984";      ARGB_FG4="0xffa89984"
HEX_GRAY="#928374";     ARGB_GRAY="0xff928374"
# accents
HEX_RED="#fb4934";      ARGB_RED="0xfffb4934"
HEX_GREEN="#b8bb26";    ARGB_GREEN="0xffb8bb26"
HEX_YELLOW="#fabd2f";   ARGB_YELLOW="0xfffabd2f"      # secondary accent (= macOS accent)
HEX_BLUE="#83a598";     ARGB_BLUE="0xff83a598"
HEX_PURPLE="#d3869b";   ARGB_PURPLE="0xffd3869b"
HEX_AQUA="#8ec07c";     ARGB_AQUA="0xff8ec07c"
HEX_ORANGE="#fe8019";   ARGB_ORANGE="0xfffe8019"      # starship leading segment

# roles the rice keys off
HEX_ACCENT="$HEX_FG";      ARGB_ACCENT="$ARGB_FG"     # active border / focused pill = cream
HEX_ACCENT2="$HEX_YELLOW"; ARGB_ACCENT2="$ARGB_YELLOW"
ARGB_INACTIVE="0xff333333"                            # inactive window border

# #rrggbb -> "38;2;r;g;b"  (for fastfetch display.color / truecolor SGR)
hex_to_sgr() {
  local h="${1#\#}"
  printf '38;2;%d;%d;%d' "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}"
}
