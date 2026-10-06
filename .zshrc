# ~/.zshrc
# Reconstructed from the running shell after the 2026-10-07 dotfiles loss.
# Known runtime state is preferred over guesses.

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
# uv is installed here in the running shell.
export PATH="$HOME/.local/bin:$PATH"

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=2000
SAVEHIST=2000
setopt HIST_IGNORE_DUPS

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
fpath=(
  /opt/homebrew/share/zsh-completions
  /opt/homebrew/share/zsh/site-functions
  $fpath
)
typeset -U fpath

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# uv completion
# _uv in the surviving shell was defined directly from ~/.zshrc.
if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi

# -----------------------------------------------------------------------------
# Aliases recovered from the running shell
# -----------------------------------------------------------------------------
alias ls='ls -G'
alias ll='ls -la'
alias proj='cd ~/projects/'

alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gco='git checkout'
alias gdiff='git diff'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'

alias tmux='tmux -f ~/.config/tmux/.tmux.conf'

# -----------------------------------------------------------------------------
# fzf
# -----------------------------------------------------------------------------
# Exact values recovered from the live shell.
export FZF_DEFAULT_OPTS='--height=25% --layout=reverse --border'
export FZF_CTRL_R_OPTS='--height=10 --layout=reverse --border'

# This recreates the observed Ctrl-T, Ctrl-R, Alt-C and completion bindings.
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# -----------------------------------------------------------------------------
# bat
# -----------------------------------------------------------------------------
# Exact value recovered from the live shell.
export BAT_THEME=ansi

# -----------------------------------------------------------------------------
# zsh-autosuggestions
# -----------------------------------------------------------------------------
# Exact source path recovered via functions_source.
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# -----------------------------------------------------------------------------
# Prompt: Pure
# -----------------------------------------------------------------------------
# prompt_pure_setup is loaded from Homebrew's site-functions.
autoload -Uz promptinit
promptinit
prompt pure

# -----------------------------------------------------------------------------
# zoxide
# -----------------------------------------------------------------------------
# __zoxide_z was sourced from ~/.zshrc in the live shell, which is consistent
# with evaluating `zoxide init zsh` here.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
