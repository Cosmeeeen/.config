# macOS Ricing

Personal desktop setup (the "rice") for **cosmins-macbook-pro** — Apple M5 Pro MacBook Pro, macOS 26 (Tahoe). Tiling window manager + custom status bar + window borders, all themed **Gruvbox**.

This repo is now a **managed dotfiles repo**: the real configs live here under `stow/` and are **symlinked** into place with [GNU Stow](https://www.gnu.org/software/stow/), so editing a file in `~/.config/…` *is* editing the repo. A `bootstrap.sh` reproduces the whole setup on a fresh Mac. (It began life as documentation-only — the detailed component notes further down are still the source of truth for *how* each piece works.)

> **New Mac, in three steps:**
> ```sh
> git clone <this-repo> ~/projects/macos-ricing && cd ~/projects/macos-ricing
> ./bootstrap.sh          # brew + fonts + omz + nvim + tmux + macOS defaults + stow
> # then put your tokens in ~/.zshrc.local, and log out/in
> ```

---

## Components

| Tool | What it does | Config |
|------|--------------|--------|
| **AeroSpace** | Tiling window manager (i3-like), 30 persistent workspaces | `~/.aerospace.toml` |
| **SketchyBar** | Custom top status bar | `~/.config/sketchybar/` |
| **JankyBorders** (`borders`) | Colored active/inactive window borders | started from `~/.aerospace.toml` `after-startup-command` |
| **Ghostty** | Terminal (floating by rule) | no config file yet |

Installed via Homebrew: `aerospace`, `sketchybar`, `borders`, `lua`. SketchyBar runs as a brew service (`brew services list`).

---

## Setup & structure

Managed with **GNU Stow** (a symlink farm) plus a few scripts:

```
macos-ricing/
  bootstrap.sh        # one-shot setup for a new Mac (brew, fonts, omz, nvim, tmux, defaults, stow)
  Brewfile            # every formula + cask (brew bundle)
  macos-defaults.sh   # the `defaults write` system tweaks (accent, hidden menu bar, desktop…)
  stow/               # one folder per "package" = the tracked configs
    sketchybar/ ghostty/ tmux/ btop/ lazygit/ fastfetch/ karabiner/ starship/ git/
    home/             # .aerospace.toml, .zshrc, .zprofile, .gitconfig, .gitignore_global
  themes/             # gruvbox.sh = palette source-of-truth (+ how to add a theme)
  lib/apply-theme.sh  # theme-switcher scaffold (not finished — see themes/README.md)
```

**Stow** links each package into `$HOME`: e.g. `~/.config/sketchybar` → `stow/sketchybar/.config/sketchybar`. Your live config *is* the repo file. Re-link manually with:
```sh
stow -d stow -t ~ --restow <package>     # or loop over stow/* for all
```

**Not tracked here (rebuilt by `bootstrap.sh`):**
- **nvim** — it's its own repo (`github.com/Cosmeeeen/nvim-config`), cloned separately. ⚠ Commit & push your nvim changes *there*; they don't live in this repo.
- **oh-my-zsh** + `zsh-autosuggestions` / `zsh-syntax-highlighting` — installed fresh.
- **tmux plugins** (`tpm` et al.) — reinstalled by tpm.
- **Fonts** — Hack Nerd Font (Brewfile cask) + sketchybar-app-font (downloaded from its release).

**Secrets — never committed.** Real tokens live in `~/.zshrc.local` (gitignored, `chmod 600`); `~/.zshrc` sources it at the end. `stow/home/.zshrc.local.example` shows what to fill in. `.gitignore` also blocks `rclone.conf`, `claude-pushover.env`, gh creds, and `*.pem`/`*.key`. (The old plaintext `NPM_TOKEN` was relocated out of `.zshrc` — **rotate it**, it was exposed.)

**Themes.** Gruvbox is currently baked into each tool. `themes/gruvbox.sh` is the palette source-of-truth and `lib/apply-theme.sh` is a scaffold toward a future `apply-theme <name>` switcher — see `themes/README.md`. (This is the "structure now, switch later" stage.)

**Rollback.** Before symlinking, the original configs were tarred to `~/rice-backups/` — restore from there if anything looks off.

---

## Theme — Gruvbox

The palette is anchored to the **borders** colors so everything matches:

- Active window border / focused accents = `0xffEBDBB2` (gruvbox cream `fg`)
- Inactive border = `0xff333333`

Full palette lives in `~/.config/sketchybar/colors.sh`. Icon glyphs in `~/.config/sketchybar/icons.sh`.

---

## SketchyBar layout

```
┌────────────────────────────────────────────────────────────────────────────┐
│  LEFT (window info)            CENTER (human)            RIGHT (system)       │
│  [workspaces] [app]            [date] ⌃notch⌄ [time]     [cpu ram] [net vol bat] │
└────────────────────────────────────────────────────────────────────────────┘
```

- **Left** — aerospace workspaces · aerospace mode (only when not in `main`) · front app (with its icon) · now-playing.
- **Center** — date + time, plain text (no icons). See **Notch handling** below.
- **Right** — CPU · RAM (one pill) · Network · Volume · Battery (one pill).
  - **Network** is icon-only: shows whichever interface is the current **default route** — Wi-Fi (`󰖩`), Ethernet (`󰈀`), or off (`󰲜`). No SSID text (see gotchas).

### Workspaces (the good part)
- Only **occupied + focused** workspaces are drawn (you have 30 persistent ones; showing them all would be noise).
- The **focused** workspace pill is highlighted in gruvbox cream (matches the borders).
- Each occupied workspace shows the **app glyphs** of the windows living in it (via `sketchybar-app-font`).
- Driven by a single hidden `space_observer` item running `plugins/aerospace.sh`, triggered by:
  - the `aerospace_workspace_change` event (fired from `~/.aerospace.toml` → `exec-on-workspace-change`),
  - `front_app_switched`,
  - a 10s poll (catches windows opening/closing).

### Notch handling (per-display, automatic)
The center date/time uses SketchyBar's special positions:
- **date → `q`** (left of the notch)
- **time → `e`** (right of the notch)
- bar has `notch_width=200`

Result:
- **Laptop screen (notched):** date sits left of the notch, time right of it — straddles it, both fully visible.
- **External monitor (no notch):** the two collapse together into the true center and read as one date/time pair (verified: ~8px apart on the 5K display).

One config, correct on every display. If you want a different notch width, change `notch_width` in `sketchybarrc`.

### Multi-display
The bar draws on **all** connected displays (docked, laptop-only, or dual). Items default to `display=all`, so the same bar appears on each screen. (Possible future improvement: show only each monitor's own workspaces per bar — not done yet.)

---

## File map — `~/.config/sketchybar/`

```
sketchybarrc          # main: bar, defaults, items, brackets, layout
colors.sh             # gruvbox palette (sourced everywhere)
icons.sh              # glyph codepoints (see "Icon gotcha" below)
helpers/
  icon_map.sh         # app-name → app-font glyph (from sketchybar-app-font release)
plugins/
  aerospace.sh        # workspace pills updater (occupied/focused + app icons)
  front_app.sh        # focused app name + icon
  media.sh            # now-playing (Music/Spotify via AppleScript)
  mode.sh             # aerospace mode indicator
  clock.sh            # time (HH:MM)
  calendar.sh         # date (Day DD Mon)
  cpu.sh  ram.sh      # system load
  wifi.sh             # network indicator (Wi-Fi/Ethernet/off, icon-only, by default route)
  volume.sh           # output volume + mute
  battery.sh          # level + charging
.backup-demo-*/       # the original FelixKratz demo config (pre-rice)
```

---

## macOS 26 (Tahoe) gotchas — important

- **Icons / fonts:** `~/Library/Fonts` was empty → every glyph rendered as a `?`/tofu box. Fix = install fonts (below).
- **Font weights:** Hack ships only **Regular + Bold** (no Semibold/Medium). Asking for a missing weight in a `:weight:` spec makes macOS silently substitute a *different* font, so items look mismatched. Stick to `Bold` or `Regular`.
- **Icon gotcha (bash 3.2):** macOS ships `/bin/bash` **3.2**, whose `printf` has **no `\U` (8-digit Unicode)**. SketchyBar may run plugins under it. So `icons.sh` defines every glyph as **octal UTF-8 escapes** (`printf '\363\260\200\265'`) — portable to any bash, and avoids raw multibyte chars in files (which can get stripped by editors). Codepoints are in the trailing comments.
- **Now-playing:** Apple restricted the MediaRemote framework on recent macOS, so `nowplaying-cli` / SketchyBar's `media_change` event are unreliable. `media.sh` queries **Music/Spotify directly via AppleScript** instead (needs Automation permission on first run; only queries apps that are already running). If it stays blank, it can be removed.
- **WiFi SSID is unavailable, period.** On macOS 26 the SSID is `<redacted>` for every unprivileged process — and **even for root** (`sudo wdutil info` also returns `<redacted>`). Location Services being on doesn't help a daemon like SketchyBar (it's ad-hoc signed → can't be granted Location). So `wifi.sh` doesn't try to show the name; it's an **icon-only** indicator of the active **default-route** interface (Wi-Fi vs Ethernet vs off), detected via `route -n get default`.
- **Screenshots of the bar:** `screencapture` from a process without Screen Recording permission **cannot see the SketchyBar overlay** (you get the windows below it). Use the macOS Screenshot UI (⇧⌘4) to capture the bar.

---

## Fonts

Installed to `~/Library/Fonts`:

| Font | Purpose | Source |
|------|---------|--------|
| **Hack Nerd Font** | All UI glyphs (status icons, workspace numbers) | `brew install --cask font-hack-nerd-font` |
| **sketchybar-app-font** | App icons (front app, workspace contents) | [kvndrsslr/sketchybar-app-font] release `sketchybar-app-font.ttf` |

`helpers/icon_map.sh` (from the same release) maps app names → app-font glyph tokens like `:slack:`.

[kvndrsslr/sketchybar-app-font]: https://github.com/kvndrsslr/sketchybar-app-font

---

## AeroSpace notes

- **Workspaces:** 30 persistent (`1`–`9`, `A`–`Z` minus a few). `alt-<key>` to focus, `alt-shift-<key>` to move window.
- **Gaps:** inner 8, outer 8, **`outer.top = 45`** (= SketchyBar height 37 + 8px gap). The macOS menu bar is auto-hidden (`_HIHideMenuBar = 1`), so the bar owns the top strip.
- **Modes:** `main` and `service` (`alt-shift-;` enters service; `esc` returns). The bar shows a red cog + `SERVICE` while in it.
- **Bar hooks added to `~/.aerospace.toml`:**
  - `exec-on-workspace-change` → triggers `aerospace_workspace_change`
  - `on-mode-changed` → triggers `aerospace_mode_change`
  - `after-startup-command` also runs `sketchybar --reload` — both apps start at login and **race**; if sketchybar wins, `aerospace list-workspaces` is empty when the config builds the workspace items, so they never get created (bar shows only the front-app). Reloading sketchybar once aerospace is up fixes it regardless of order. (If it ever recurs, just run `sketchybar --reload`.)
- **Ghostty** is floating (`on-window-detected` rule) and opens with `alt-enter`.
  - **Why floating?** macOS native tabs (Ghostty's only tab mode — `macos-titlebar-style = tabs` is cosmetic) expose each tab as a *separate window* to the AX API, so AeroSpace tiles every tab → broken layout. Non-native tabs are an unimplemented Ghostty feature ([#10711](https://github.com/ghostty-org/ghostty/issues/10711); see [ghostty docs: macos-tiling-wms](https://ghostty.org/docs/help/macos-tiling-wms)). So it's float-with-native-tabs **or** tile-without-native-tabs — not both.
  - **Tab-like while tiled:** set the rule to `layout tiling`, open windows (`alt-enter`), and use accordion layout (`alt-,`) to stack them like tabs, switching with `alt-h/l`. Optionally remap Ghostty `⌘T → new_window`.

---

## Operating it

```sh
# reload after editing the bar
sketchybar --reload

# reload aerospace after editing ~/.aerospace.toml
aerospace reload-config

# logs / debugging
brew services list | grep sketchybar
tail -f /opt/homebrew/var/log/sketchybar/*   # if logging enabled
```

Common tweaks:
- **Colors** → `colors.sh`
- **Which widgets / order** → `sketchybarrc`
- **Notch width** → `notch_width` in `sketchybarrc`
- **Add an icon** → add a codepoint line to `icons.sh` (verify it exists in Hack Nerd Font first)

---

## Restore the original demo

The stock FelixKratz demo config was backed up before ricing:

```sh
ls ~/.config/sketchybar/.backup-demo-*/
# copy sketchybarrc + plugins/ back from there, then: sketchybar --reload
```

---

## Terminal, shell & editor (all gruvbox)

| Tool | Theme / change | Config |
|------|----------------|--------|
| **Ghostty** | `Gruvbox Dark Hard`, `Hack Nerd Font Mono` 16, bg `1d2021` @ 85% + blur | `~/.config/ghostty/config` |
| **tmux** | transparent gruvbox status bar (cream / yellow current / blue session) | `~/.config/tmux/tmux.conf` |
| **btop** | `gruvbox_dark_v2`, transparent background | `~/.config/btop/btop.conf` |
| **starship** | `gruvbox-rainbow` preset | `~/.config/starship.toml` |
| **nvim** | `ellisonleao/gruvbox.nvim` (hard contrast, transparent) | `~/.config/nvim` |
| **fastfetch** | gruvbox icon-key system splash, recolored apple logo | `~/.config/fastfetch/config.jsonc` |

### Fixed along the way
- **Ghostty config never loaded** — it was named `config.ghostty`; Ghostty only reads `~/.config/ghostty/config`. Renamed (the old file was on defaults the whole time).
- **nvim**: bamboo.nvim → gruvbox.nvim · removed `vim-be-good` · fixed fidget's invalid `hide_on_status` · installed `ripgrep` + `fd` (Telescope live-grep was throwing `rg: not found`) · disabled unused perl/ruby/python/node providers to quiet `:checkhealth`.
- Benign `:checkhealth` noise left as-is: missing formatters (only matter when formatting that filetype) and language toolchains you don't use.
- **oh-my-zsh + starship** both load in `.zshrc` (starship wins; OMZ prompt wasted) and OMZ is sourced twice — slimming pending.

## Bar — second pass
- **Transparent bar** (`BAR_COLOR=0x00000000`) — pills/text float over the wallpaper, no tint.
- **Apple logo removed**; the left now starts with workspaces.
- **Date/time**: plain centered text with hierarchy — large cream time + small muted UPPERCASE date (no icons).
- **Network** widget is icon-only — Wi-Fi / Ethernet / off, chosen by the active **default route**.
- **Caffeine** widget (`plugins/caffeine.sh`): coffee icon shows only while `caffeinate`/Amphetamine holds a **`PreventUserIdleDisplaySleep`** assertion (screen-awake) in `pmset -g assertions` — *not* system-sleep-only blockers like `caffeinate -i` or background tasks. Polls every 10s (`updates=on` so it updates while hidden).
- Invisible spacer (`rgap`) between the two right-side pills.
- **Claude session status** (`plugins/claude.sh` + hook `~/.claude/hooks/sketchybar-claude/state.sh`): aggregates **all** Claude Code sessions, shown via the icon (no animation) — bell `󰃞` **needs input** (gruvbox red `#fb4934`) / check `󰗠` **done** (tan, auto-hides ~10s then disappears) / robot `󰚩` **working** (dim gray) — hidden when idle, with a count when >1. Priority: needs-input > done > working. State is driven by hooks in `~/.claude/settings.json` (UserPromptSubmit/Stop/Notification/PermissionRequest/SessionEnd, alongside peon-ping) writing to `~/.claude/sketchybar-state/<session-id>`. Remove = delete the widget block + those 5 hook entries.

## Desktop
- Desktop icons hidden: `defaults write com.apple.finder CreateDesktop -bool false && killall Finder`. Widgets were already hidden (`StandardHideWidgets=1`); Stage Manager off.
- Click-wallpaper-to-reveal-desktop disabled: `defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false`.

## macOS system + Claude Code
- **Accent color = Yellow** (`defaults write -g AppleAccentColor -int 2`) + matching yellow highlight — closest match to gruvbox / the bar's accent. Alt: Orange. **Log out/in for full effect** across all apps.
- Keep **Dark** + transparency **on** (do NOT enable "Reduce transparency" — it kills the translucent bar/terminal).
- **`.zshrc`**: oh-my-zsh was being sourced twice → deduped; `ZSH_THEME=""` since starship owns the prompt. ⚠️ a GitHub/NPM token was stored in plaintext here — **rotate it**.
- **Claude Code statusline** (`~/.claude/statusline-command.sh`): gruvbox-colored — aqua dir · yellow branch · orange git status · gray model · blue→yellow→red context.
- **nvim Copilot**: kept (still maintained; node v24 present). Run `:Copilot setup` once to authenticate.

## Round 3 additions
- **Modern CLI tools** (gruvbox): `eza` (ls aliases), `bat` (`BAT_THEME=gruvbox-dark`), `fzf` (Ctrl-T/Ctrl-R, gruvbox colors, `fd` backend + `bat` preview), `zoxide` (`z`), `lazygit` (`lg`, themed `~/.config/lazygit/config.yml`), `delta` (git pager, `gruvbox-dark`). Wired in `~/.zshrc` + `~/.gitconfig`. Open a new shell to load.
- **Tailscale** bar widget (`plugins/tailscale.sh`): icon-only shield — muted = connected, dim = down, hidden if no CLI. Sits in the status pill next to the network icon.
- **Per-monitor workspaces**: `plugins/aerospace.sh` sets each workspace pill's `display` to its `%{monitor-id}`, so each screen's bar shows only its own workspaces. Single-monitor = no visible change; **verify when docked + laptop open** (if monitors look swapped, aerospace monitor-id vs sketchybar display index may need an offset).
- **tmux resurrect + continuum**: auto-saves every 15 min, auto-restores on server start (nvim sessions too). Plugins in `~/.config/tmux/plugins/`. (Pre-existing `sessionx` is declared after `run tpm` so it never loaded — left as-is.)
- **Pushover idle alerts**: `~/.claude/hooks/sketchybar-claude/state.sh` pings Pushover for needs-input/done **only when idle ≥120s** (no mouse/keyboard, via `ioreg HIDIdleTime`), 60s per-session cooldown. Enable by adding keys to `~/.config/claude-pushover.env` (chmod 600).

## fastfetch — terminal system splash
Themed to read as "the bar, in the terminal". Config: `~/.config/fastfetch/config.jsonc`.

- **Logo** — a 3D ASCII logo (`~/.config/fastfetch/cosmin.txt`), gradient cream `#ebdbb2` → yellow `#fabd2f` → orange `#fe8019` via the file's `$1`/`$2`/`$3` color markers. Pure ASCII → renders on any terminal. (A commented `kitty` image-logo block remains as an optional alternative.)
- **Icon-key column** — every module's key is a single Nerd Font (MDI) glyph + a thin gray `│` + cream value. Same glyph-only language as the SketchyBar pills; key colors cycle the gruvbox accents per group (orange/yellow/aqua/blue/purple), echoing the starship rainbow segment order.
- **Shows** — OS · host · kernel · uptime · brew packages · shell (zsh + starship) · **AeroSpace** version (pulled live by a `command` module running `aerospace --version`, so it never goes stale) · Ghostty · CPU · GPU · memory + **swap** (gruvbox meter bars `██████────`) · disk(`/`) · display (with monitor model) · default-route IP · battery · power adapter · padded date/time · palette swatch.
- **Meters** — `display.percent` uses gruvbox green/yellow/red thresholds; bar chars `█`/`─`.

### fastfetch gotchas
- **PUA glyphs get stripped on save (same trap as `icons.sh`).** Editors/tools silently drop raw BMP Private-Use chars (U+E000–U+F8FF — e.g. the `nf-dev`  shell glyph), turning `"key": ""` into an empty string; fastfetch then falls back to the plain `Shell` text label and breaks the icon column. Fix = use **MDI-range glyphs (U+F0000+, the `nf-md-*` set)**, which survive — the shell key is `nf-md-console-line` 󰞷 (U+F07B7). Pick any new key glyph from the `F0xxx` range.
- **Piped output is colorless.** `fastfetch | cat` (or any non-tty) strips all color — judge it in a real Ghostty window, not a pipe.
- **Colors are hex `#fabd2f` for logo/title but SGR truecolor `38;2;r;g;b` for `display.color`** output/separator — fastfetch 2.65 accepts both forms.
- **Optional image logo** — a commented `kitty` block sits in the config: drop a gruvbox-recolored ~600px PNG at `~/.config/fastfetch/logo.png`, comment the builtin block, uncomment the kitty one (Ghostty speaks the kitty graphics protocol). A missing/invalid PNG **silently** falls back to the *default rainbow* apple (not the gruvbox one) — so keep the builtin block until the PNG exists.

Tweaks: add/remove a line → the `modules` array · recolor a key → its `keyColor` · run on shell start → add `fastfetch` to `~/.zshrc` (optional; not enabled, it slows every new shell).

---

## License

[GPL-3.0](LICENSE) © 2026 Cosmin Ilie. Includes small snippets adapted from permissively-licensed projects (FelixKratz's SketchyBar demo, `sketchybar-app-font`, a starship preset) — their notices are retained.
