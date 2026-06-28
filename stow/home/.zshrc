# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt AUTO_CD

# fnm (Node version manager)
eval "$(fnm env --use-on-cd --shell zsh)"

# Aliases - Navigation
alias ..="cd .."
alias ...="cd ../.."
alias finder="open ."
alias reload="source ~/.zshrc"

# Aliases - Git
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph"

# Aliases - Neovim
alias vim="nvim"
alias vi="nvim"

# Aliases - tmux
alias tls="tmux ls"

# Aliases - tmux project layouts
alias tclaude="$HOME/.config/tmux/scripts/tmux-claude.sh"
alias tvps="$HOME/.config/tmux/scripts/tmux-vps.sh"

# Fun personal aliases
alias cwd="pwd | pbcopy"

# Oh My Zsh — plugins/completions only; prompt is handled by starship
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# ── Modern CLI tools ──────────────────────────────────────────
export BAT_THEME="gruvbox-dark"

# fzf (gruvbox colors, fd backend, bat preview on Ctrl-T)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border \
  --color=bg+:#3c3836,spinner:#fe8019,hl:#928374,fg:#ebdbb2 \
  --color=header:#928374,info:#8ec07c,pointer:#fe8019,marker:#fe8019 \
  --color=fg+:#ebdbb2,prompt:#fabd2f,hl+:#fabd2f,border:#504945"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# eza (modern ls) + shortcuts
alias ls="eza --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias lt="eza --tree --level=2 --icons"
alias lg="lazygit"
# ──────────────────────────────────────────────────────────────

# Starship (always last)
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"

# Machine-local secrets (tokens, keys) — untracked. See ~/.zshrc.local.example
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
