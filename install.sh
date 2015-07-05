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
  rel_path="$1"
  source_path="$PWD/$rel_path"
  dest_path="$HOME/$rel_path"

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
  echo "symlinked $dest_path"
}

echo "setting gnome-terminal colourscheme"
./gnome-terminal-jellybeans.sh
symlink .gitconfig
symlink .gitignore.global
symlink .vimrc
symlink .vim/UltiSnips
symlink .vim/autoload/plug.vim &&
  note "remember to run :PlugInstall and build YCM"
mkdir -p ~/.vim/backup
symlink .config/fish/config.fish &&
  note "you may want to run fish_update_completions"
symlink .i3/config
