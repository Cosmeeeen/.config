#!/usr/bin/env bash
# Gruvbox palette — matches the aerospace `borders` colors (cream active / dark inactive).
# Format is 0xAARRGGBB.

# Base tones
export BLACK=0xff1d2021   # bg0_hard
export BG0=0xff282828
export BG0_SOFT=0xff32302f
export BG1=0xff3c3836
export BG2=0xff504945
export BG3=0xff665c54
export FG=0xffebdbb2      # == borders active_color
export FG4=0xffa89984
export GRAY=0xff928374

# Accents
export RED=0xfffb4934
export GREEN=0xffb8bb26
export YELLOW=0xfffabd2f
export BLUE=0xff83a598
export PURPLE=0xffd3869b
export AQUA=0xff8ec07c
export ORANGE=0xfffe8019

# Semantic
export WHITE=$FG
export BAR_COLOR=0x00000000      # fully transparent
export ITEM_BG=0xff3c3836        # pill background
export ACCENT=$YELLOW

# Workspace pill states
export WS_FOCUS_BG=$FG           # focused = cream (matches borders)
export WS_FOCUS_FG=$BLACK
export WS_OCC_BG=$BG2            # occupied but unfocused
export WS_OCC_FG=$FG

export NERD_FONT="Hack Nerd Font"
export APP_FONT="sketchybar-app-font"
