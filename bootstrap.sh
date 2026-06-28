#!/usr/bin/env bash
# One-shot setup for this rice on a fresh macOS machine. Re-runnable.
# Read it before running. Nothing here force-overwrites your data.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO" || exit 1

log()  { printf '\n\033[1;33m▸ %s\033[0m\n' "$1"; }
ok()   { printf '  \033[0;32m✓\033[0m %s\n' "$1"; }
warn() { printf '  \033[0;31m!\033[0m %s\n' "$1"; }

# 1) Homebrew
log "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
ok "brew $(brew --version | head -1)"

# 2) Packages (formulae + casks) from the Brewfile
log "Brew bundle (formulae + casks — can take a while)"
brew bundle --file="$REPO/Brewfile" || warn "some brew items failed — safe to re-run later"

# 3) Fonts — Hack Nerd Font is a Brewfile cask; sketchybar-app-font is a release asset
log "Fonts"
APPFONT="$HOME/Library/Fonts/sketchybar-app-font.ttf"
if [ ! -f "$APPFONT" ]; then
  if curl -fsSL -o "$APPFONT" \
       https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/sketchybar-app-font.ttf; then
    ok "sketchybar-app-font"
  else warn "sketchybar-app-font download failed (grab it manually)"; fi
else ok "sketchybar-app-font present"; fi

# 4) oh-my-zsh + custom plugins
log "oh-my-zsh"
[ -d "$HOME/.oh-my-zsh" ] || RUNZSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ZC="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ -d "$ZC/plugins/zsh-autosuggestions" ]      || git clone -q https://github.com/zsh-users/zsh-autosuggestions "$ZC/plugins/zsh-autosuggestions"
[ -d "$ZC/plugins/zsh-syntax-highlighting" ]  || git clone -q https://github.com/zsh-users/zsh-syntax-highlighting "$ZC/plugins/zsh-syntax-highlighting"
ok "omz + plugins"

# 5) Stow all packages (symlink configs into place)
log "Stow"
for pkg in "$REPO"/stow/*/; do
  p="$(basename "$pkg")"
  if err=$(stow -d "$REPO/stow" -t "$HOME" --restow "$p" 2>&1); then ok "stow $p"
  else
    warn "stow $p hit conflicts:"; printf '%s\n' "$err" | sed 's/^/      /'
    warn "back up the conflicting file(s) shown above, then: stow -d stow -t ~ --adopt $p"
  fi
done

# 6) Neovim config (its own repo — has uncommitted local changes on the source Mac, so push those first!)
log "Neovim config"
if [ ! -e "$HOME/.config/nvim" ]; then
  git clone https://github.com/Cosmeeeen/nvim-config.git "$HOME/.config/nvim" && ok "nvim cloned"
else ok "nvim present"; fi

# 7) tmux plugin manager + plugins
log "tmux plugins"
TPM="$HOME/.config/tmux/plugins/tpm"
[ -d "$TPM" ] || git clone -q https://github.com/tmux-plugins/tpm "$TPM"
"$TPM/bin/install_plugins" >/dev/null 2>&1 && ok "tpm + plugins" \
  || warn "open tmux and press prefix+I to finish plugin install"

# 8) Secrets
log "Secrets"
if [ ! -f "$HOME/.zshrc.local" ]; then
  if cp "$HOME/.zshrc.local.example" "$HOME/.zshrc.local" 2>/dev/null; then
    chmod 600 "$HOME/.zshrc.local"
    warn "created ~/.zshrc.local from the example — EDIT IT and add your real tokens"
  else warn "no ~/.zshrc.local.example (home package not stowed?) — create ~/.zshrc.local manually"; fi
else ok "found ~/.zshrc.local"; fi
if [ ! -f "$HOME/.gitconfig.local" ]; then
  if cp "$HOME/.gitconfig.local.example" "$HOME/.gitconfig.local" 2>/dev/null; then
    warn "created ~/.gitconfig.local — set your real git name/email"
  else warn "create ~/.gitconfig.local with your [user] name/email"; fi
else ok "found ~/.gitconfig.local"; fi

# 9) macOS system tweaks
log "macOS defaults"
bash "$REPO/macos-defaults.sh"

# 10) Services + reload
log "Services"
if brew services start sketchybar 2>/dev/null; then ok "sketchybar service"; else warn "start sketchybar manually"; fi
command -v aerospace >/dev/null 2>&1 && aerospace reload-config 2>/dev/null || true
sketchybar --reload 2>/dev/null || true

log "Done"
echo "• Log out/in for the accent color + menu-bar changes."
echo "• AeroSpace & SketchyBar start at login. If the bar looks empty: sketchybar --reload"
echo "• Don't forget to fill in ~/.zshrc.local (and rotate any leaked tokens)."
