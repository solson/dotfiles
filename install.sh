#!/bin/bash

# Create symlinks in ~ for files in the current directory.

# Copyright © 2015, Scott Olson <scott@scott-olson.org>
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

note() {
  echo "  - $1"
}

symlink() {
  # The path to the config file in ~, e.g. ".config/foo.conf".
  local rel_path="$1"

  # The extra suffix on the source file compared to the target, e.g. ".foobar"
  # if you want to link ".config/foo.conf.foobar" to ".config/foo.conf". This is
  # often useful for hostname-specific configuration files.
  local source_suffix="$2"

  local source_path="$PWD/$rel_path$source_suffix"
  local dest_path="$HOME/$rel_path"

  if [ ! -e "$source_path" ]; then
    echo "error: $source_path doesn't exist"
    return 1
  fi

  if [ -L "$dest_path" ]; then
    echo "ignoring $dest_path (already symlinked)"
    return 1
  fi

  if [ -e "$dest_path" ]; then
    echo "ignoring $dest_path (destination exists)"
    return 1
  fi

  mkdir -p "$(dirname "$dest_path")"
  ln -s "$source_path" "$dest_path"
  echo "symlinked $dest_path -> $source_path"
}

# Git
symlink .gitconfig
symlink .gitignore.global

# Vim
mkdir -p ~/.vim/backup
symlink .vimrc
symlink .vim/UltiSnips
symlink .vim/autoload/plug.vim &&
  note "remember to run :PlugInstall and build YCM"

# i3
symlink .i3/config
symlink .i3/autostart.sh ".$(hostname -s)"
symlink .config/i3status/config ".$(hostname -s)"

# Misc.
echo "setting gnome-terminal settings"
./gnome-terminal-jellybeans.sh
symlink .config/fontconfig/fonts.conf
symlink .config/fish/config.fish &&
  note "you may want to run fish_update_completions"
