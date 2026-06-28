# Themes

The rice is **Gruvbox**. The same ~16 colors are embedded across ~10 tools
(sketchybar, ghostty, btop, starship, fastfetch, fzf, bat, delta, lazygit).

This folder is the **structure** for theme-switching — not a finished switcher yet
(that's the "switch later" half of the plan).

- **`gruvbox.sh`** — the single source of truth for the palette, exported in every
  format the tools need (`#hex`, `0xAARRGGBB`, and `38;2;r;g;b` via `hex_to_sgr`).
- **`../lib/apply-theme.sh`** — a scaffold that loads a palette and maps out where
  each tool's colors would be rewritten. The per-tool rewrites are TODO.

### To add a theme later
1. `cp gruvbox.sh nord.sh` and change the values.
2. Implement the `apply_*` functions in `../lib/apply-theme.sh` (each rewrites one
   tool's color file from the palette vars, then reloads that app).
3. `./lib/apply-theme.sh nord`.

Until then, gruvbox lives baked into each tool's config — switching means editing
those files (or finishing the switcher above).
