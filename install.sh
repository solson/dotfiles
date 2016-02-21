#!/bin/bash

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

  symlink-absolute "$dest_path" "$source_path"
}

symlink-absolute() {
  local dest_path="$1"
  local source_path="$2"

  if [ ! -e "$source_path" ]; then
    msg Error "$source_path doesn't exist"
    return 1
  fi

  if [ -L "$dest_path" ]; then
    msg Up-to-date "$dest_path"
    return 1
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

setup-git() {
  symlink .gitconfig
  symlink .gitignore.global
}

setup-vim() {
  mkdir -p ~/.vim/backup
  symlink .vimrc
  symlink .vim/UltiSnips
  symlink .vim/autoload/plug.vim &&
    msg Note "remember to run :PlugInstall and build YCM"

  symlink-absolute "$HOME/.config/nvim" "$HOME/.vim"
  symlink-absolute "$HOME/.config/nvim/init.vim" "$HOME/.vimrc"
}

setup-fish() {
  symlink .config/fish/config.fish &&
    msg Note "you may want to run fish_update_completions"
}

setup-common() {
  setup-git
  setup-vim
  setup-fish
  symlink .inputrc
  symlink .profile
  symlink bin/vigpg
  symlink bin/manpager
  symlink bin/format-duration
  symlink bin/notify-run
  symlink bin/tmux-status
}

setup-i3() {
  symlink .i3/config
  symlink .i3/autostart.sh        ".i3/autostart.sh.$(hostname -s)"
  symlink .config/i3status/config ".config/i3status/config.$(hostname -s)"
}

setup-gnome-terminal() {
  msg Note "run ./gnome-terminal-jellybeans.sh to set gnome-terminal settings"
}

setup-common-gui() {
  setup-common
  symlink .gtkrc-2.0.mine &&
    msg Note "make sure .gtkrc-2.0 includes .gtkrc-2.0.mine (run LXAppearance)"
  symlink .config/fontconfig/fonts.conf
  setup-i3
  setup-gnome-terminal
}

case "$(hostname -s)" in
  neutron)
    setup-common-gui
    symlink .tmux.conf
    ;;

  spark)
    setup-common-gui
    ;;

  scott-ubuntu-hci)
    setup-common-gui
    ;;

  quark)
    setup-common
    ;;

  *)
    msg Error "unknown machine '$(hostname -s)'"
    ;;
esac
