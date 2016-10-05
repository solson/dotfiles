#!/bin/sh

# Create symlinks in ~ for files in the current directory.

# Copyright © 2015, Scott Olson <scott@solson.me>
# Copyright © 2015, Curtis McEnroe <curtis@cmcenroe.me>
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
      dest_path="$HOME/$1"
      source_path="$PWD/$1"
      ;;
    2)
      dest_path="$HOME/$1"
      source_path="$PWD/$2"
      ;;
    *)
      msg Error "Expected 1 or 2 arguments to symlink, got $#"
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
  symlink .gitconfig
  symlink .gitignore.global
}

setup_vim() {
  mkdir -p ~/.vim/backup
  symlink .vimrc
  symlink .vim/UltiSnips
  symlink .vim/colors/solson.vim
  symlink .vim/autoload/plug.vim &&
    msg Note "remember to run :PlugInstall and build YCM"

  symlink_absolute "$HOME/.config/nvim" "$HOME/.vim"
  symlink_absolute "$HOME/.config/nvim/init.vim" "$HOME/.vimrc"
}

setup_fish() {
  symlink .config/fish/config.fish &&
    msg Note "you may want to run fish_update_completions"
}

setup_bash() {
  symlink .bashrc
  symlink .bash_profile
}

setup_common() {
  setup_git
  setup_vim
  setup_fish
  setup_bash
  symlink .inputrc
  symlink .irbrc
  symlink .nix-repl.nix
  symlink .bin/vigpg
  symlink .bin/manpager
  symlink .bin/format-duration
  symlink .bin/notify-run
  symlink .bin/tmux-status
}

setup_i3() {
  symlink .i3/config
  symlink .i3/autostart.sh        ".i3/autostart.sh.$(hostname -s)"
  symlink .config/i3status/config ".config/i3status/config.$(hostname -s)"
}

setup_gnome_terminal() {
  msg Note "run ./gnome-terminal-jellybeans.sh to set gnome-terminal settings"
}

setup_common_gui() {
  setup_common
  symlink .gtkrc-2.0.mine &&
    msg Note "make sure .gtkrc-2.0 includes .gtkrc-2.0.mine (run LXAppearance)"
  symlink .config/fontconfig/fonts.conf
  setup_i3
  setup_gnome_terminal
}

case "$(hostname -s)" in
  conway)
    setup_common
    symlink .tmux.conf
    ;;

  neutron)
    setup_common_gui
    symlink .tmux.conf
    ;;

  scott-ubuntu-hci)
    setup_common_gui
    ;;

  quark)
    setup_common
    symlink .tmux.conf
    ;;

  *)
    msg Error "unknown machine '$(hostname -s)'"
    ;;
esac
