#!/usr/bin/env bash
# Create symlinks from ~ to this repository.
set -euo pipefail

msg() {
  printf "%10s %s\n" "$1" "$2"
}

symlink() {
  local dest_path
  local source_path

  case $# in
    1)
      dest_path="$HOME/.$1"
      source_path="$PWD/$1"
      ;;
    *)
      msg Error "Expected 1 argument to symlink, got $#"
      msg Error "Arguments were: $*"
      return 1
      ;;
  esac

  symlink_absolute "$dest_path" "$source_path"
}

symlink_absolute() {
  local dest_path="$1"
  local source_path="$2"

  if [ ! -e "$source_path" ]; then
    msg Error "$source_path doesn't exist"
    return
  fi

  if [ -L "$dest_path" ]; then
    local current_dest="$(readlink "$dest_path")"
    if [ "$current_dest" != "$source_path" ]; then
      msg Error "$dest_path points to to $current_dest"
    else
      msg Up-to-date "$dest_path"
    fi
    return
  fi

  if [ -e "$dest_path" ]; then
    msg Error "$dest_path exists and isn't a symlink"
    return
  fi

  mkdir -p "$(dirname "$dest_path")"
  ln -s "$source_path" "$dest_path"
  msg Linking "$dest_path -> $source_path"
}

symlink bash_profile
symlink bashrc
symlink bin/format-duration
symlink bin/notify-run
symlink bin/vigpg
symlink config/bat
symlink config/broot
symlink config/fish
symlink config/git
symlink config/irb
symlink config/nix
symlink config/nvim
symlink config/readline
symlink config/X11
symlink local/share/konsole/VSCode-WIP.colorscheme
symlink tmux.conf

exit 0
