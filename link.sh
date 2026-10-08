#!/bin/sh

set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date '+%Y%m%d-%H%M%S')"
BACKED_UP=0

link_dotfile() {
  src="$DOTFILES_DIR/$1"
  dest="$HOME/$1"

  if [ ! -e "$src" ]; then
    printf 'error: source does not exist: %s\n' "$src" >&2
    exit 1
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    printf 'skip: %s already links to %s\n' "$dest" "$src"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    backup="$BACKUP_DIR/$1"
    mkdir -p "$(dirname -- "$backup")"
    mv -- "$dest" "$backup"
    BACKED_UP=1
    printf 'backup: %s -> %s\n' "$dest" "$backup"
  fi

  mkdir -p "$(dirname -- "$dest")"
  ln -s "$src" "$dest"
  printf 'link: %s -> %s\n' "$dest" "$src"
}

link_dotfile ".zshrc"
link_dotfile ".vimrc"
link_dotfile ".config/starship.toml"
link_dotfile ".config/alacritty"
link_dotfile ".config/ghostty"
link_dotfile ".config/nvim"
link_dotfile ".config/tmux"
link_dotfile ".config/wezterm"

if [ "$BACKED_UP" -eq 1 ]; then
  printf '\nExisting files were backed up to: %s\n' "$BACKUP_DIR"
fi
