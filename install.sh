#!/bin/sh

# Create symlinks in ~ for files in the current directory.

# Copyright © 2019, Scott Olson <scott@solson.me>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

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
      exit 1
      ;;
  esac

  symlink_absolute "$dest_path" "$source_path"
}

symlink_absolute() {
  local dest_path="$1"
  local source_path="$2"

  if [ ! -e "$source_path" ]; then
    msg Error "$source_path doesn't exist"
    return 1
  fi

  if [ -L "$dest_path" ]; then
    local current_dest="$(readlink "$dest_path")"
    if [ "$current_dest" != "$source_path" ]; then
      msg Error "$dest_path points to to $current_dest"
    else
      msg Up-to-date "$dest_path"
      return 1
    fi
  fi

  if [ -e "$dest_path" ]; then
    msg Error "$dest_path exists and isn't a symlink"
    return 1
  fi

  mkdir -p "$(dirname "$dest_path")"
  ln -s "$source_path" "$dest_path"
  msg Linking "$dest_path -> $source_path"
}

################################################################################

setup_git() {
  symlink config/git/attributes
  symlink config/git/config
  symlink config/git/ignore
}

setup_vim() {
  mkdir -p ~/.vim/backup
  symlink vimrc
  symlink vim/colors
  symlink vim/autoload/airline
  symlink vim/autoload/plug.vim &&
    msg Note "remember to run :PlugInstall and build YCM"

  symlink_absolute "$HOME/.config/nvim" "$HOME/.vim"
  symlink_absolute "$HOME/.config/nvim/init.vim" "$HOME/.vimrc"
}

setup_fish() {
  symlink config/fish/config.fish &&
    msg Note "you may want to run fish_update_completions"
  symlink config/fish/autojump.fish
}

setup_bash() {
  symlink bashrc
  symlink bash_profile
}

setup_common() {
  setup_git
  setup_vim
  setup_fish
  setup_bash
  symlink bin/format-duration
  symlink bin/notify-run
  symlink bin/vigpg
  symlink config/bat
  symlink inputrc
  symlink irbrc
  symlink nix-repl.nix
  symlink XCompose
  symlink local/share/konsole/VSCode-WIP.colorscheme
}

case "$(hostname -s)" in
  conway)
    setup_common
    symlink tmux.conf
    ;;

  *)
    msg Error "unknown machine '$(hostname -s)'"
    ;;
esac
