# ~/.config/zsh/functions/fzf.zsh
# fzf helpers for ghq, git and files. Sourced from ~/.zshrc after `fzf --zsh`.

# -----------------------------------------------------------------------------
# Shared options
# -----------------------------------------------------------------------------
# Inside tmux, the stock Ctrl-T / Ctrl-R / Alt-C widgets and _fzf_popup open
# fzf in a popup; outside tmux they use FZF_DEFAULT_OPTS as is.
export FZF_TMUX_OPTS='-p 85%,85%'

_fzf_walker_skip='.git,node_modules,.venv,.direnv,__pycache__,.mypy_cache,.pytest_cache,.ruff_cache'

if command -v bat >/dev/null 2>&1; then
  _fzf_cat='bat --color=always --style=numbers --line-range=:500'
else
  _fzf_cat='head -n 500'
fi
_fzf_file_preview="$_fzf_cat -- {}"

# gcd preview: git status, then README.md (or another README*) if present.
_gcd_preview='git -C {} status --short --branch --untracked-files=normal
f={}/README.md
[ -f "$f" ] || f=$(find {} -maxdepth 1 -type f -iname "readme*" | sort | head -n 1)
[ -n "$f" ] && { echo; '"$_fzf_cat"' -- "$f"; }'

export FZF_CTRL_T_OPTS="--walker-skip=$_fzf_walker_skip --preview '[ -d {} ] && ls -G {} || $_fzf_file_preview'"
export FZF_ALT_C_OPTS="--walker-skip=$_fzf_walker_skip --preview 'ls -G {}'"

# Ctrl-R: keep history search inline under the prompt even inside tmux.
# fzf's __fzfcmd only uses fzf-tmux when FZF_TMUX_OPTS is non-empty.
_fzf_history_inline_widget() {
  local FZF_TMUX_OPTS= FZF_TMUX=0
  zle fzf-history-widget
}
if (( $+widgets[fzf-history-widget] )); then
  zle -N _fzf_history_inline_widget
  bindkey -M emacs '^R' _fzf_history_inline_widget
  bindkey -M vicmd '^R' _fzf_history_inline_widget
  bindkey -M viins '^R' _fzf_history_inline_widget
fi

# Run fzf the same way as the stock widgets: popup in tmux, inline otherwise.
_fzf_popup() {
  if [[ -n ${TMUX_PANE-} ]] && (( $+commands[fzf-tmux] )); then
    fzf-tmux ${=FZF_TMUX_OPTS} -- "$@"
  else
    fzf "$@"
  fi
}

_fzf_require() {
  local cmd
  for cmd in "$@"; do
    if ! (( $+commands[$cmd] )); then
      print -u2 "${funcstack[2]}: command not found: $cmd"
      return 127
    fi
  done
}

_fzf_in_git_repo() {
  _fzf_require git || return
  git rev-parse --git-dir >/dev/null || return
}

# -----------------------------------------------------------------------------
# Repositories
# -----------------------------------------------------------------------------
# gcd: cd to a ghq-managed repository.
gcd() {
  _fzf_require ghq fzf || return
  local dir
  dir=$(ghq list -p | _fzf_popup --scheme=path --prompt='repo> ' \
    --preview "$_gcd_preview") || return
  [[ -n $dir ]] && builtin cd -- "$dir"
}

# Ctrl-G: same as gcd. Like fzf's Alt-C, run cd through the command line so
# the prompt and history are updated.
_gcd_widget() {
  setopt localoptions pipefail no_aliases 2>/dev/null
  _fzf_require ghq fzf || { zle reset-prompt; return 1 }
  local dir
  dir=$(ghq list -p | _fzf_popup --scheme=path --prompt='repo> ' \
    --preview "$_gcd_preview")
  if [[ -z $dir ]]; then
    zle redisplay
    return 0
  fi
  zle push-line
  BUFFER="builtin cd -- ${(q)dir}"
  zle accept-line
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N _gcd_widget
bindkey -M emacs '^G' _gcd_widget
bindkey -M viins '^G' _gcd_widget

# groot: cd to the root of the current Git repository.
groot() {
  _fzf_require git || return
  local root
  root=$(git rev-parse --show-toplevel) || return
  builtin cd -- "$root"
}

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------
# fbr: switch to a local branch. Uncommitted changes are left to git switch.
fbr() {
  _fzf_require fzf && _fzf_in_git_repo || return
  local branch
  branch=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads |
    _fzf_popup --prompt='branch> ' \
      --preview 'git log --oneline --graph --decorate --color=always -n 50 {}') || return
  [[ -n $branch ]] && git switch "$branch"
}

# fbrm: switch to a remote branch, creating a tracking branch if needed.
fbrm() {
  _fzf_require fzf && _fzf_in_git_repo || return
  local branch
  branch=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/remotes |
    grep -v '/HEAD$' |
    _fzf_popup --prompt='remote branch> ' \
      --preview 'git log --oneline --graph --decorate --color=always -n 50 {}') || return
  [[ -n $branch ]] || return 0
  local local_branch=${branch#*/}
  if git show-ref --verify --quiet "refs/heads/$local_branch"; then
    git switch "$local_branch"
  else
    git switch --track "$branch"
  fi
}

# flog: browse commits and show the selected one. Read-only.
flog() {
  _fzf_require fzf && _fzf_in_git_repo || return
  local line
  line=$(git log --color=always --format='%C(auto)%h%d %s %C(blue)%an %C(green)%cr' "$@" |
    _fzf_popup --ansi --no-sort --prompt='log> ' \
      --preview 'git show --color=always --stat --patch {1}') || return
  [[ -n $line ]] && git show "${line%% *}"
}

# -----------------------------------------------------------------------------
# Files
# -----------------------------------------------------------------------------
# fe: open files in Neovim. Tab selects multiple files.
fe() {
  _fzf_require fzf nvim || return
  local out
  out=$(_fzf_popup -m --scheme=path --prompt='file> ' \
    --walker=file,follow,hidden --walker-skip="$_fzf_walker_skip" \
    --preview "$_fzf_file_preview") || return
  [[ -n $out ]] && nvim -- "${(@f)out}"
}
