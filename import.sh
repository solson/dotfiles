#!/bin/bash

# Import a file from ~ and replace it with a symlink.

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

set -e

error() {
  echo "$1"
  exit 1
}

[ -z "$1" ] && error "no path"

rel_path="$1"
source_path="$HOME/$rel_path"
dest_path="$PWD/$rel_path"

[ -f "$dest_path" ] && error "$dest_path already exists"
[ -f "$source_path" ] || error "$source_path does not exist"

mkdir -p "$(dirname "$dest_path")"
mv "$source_path" "$dest_path"
ln -s "$dest_path" "$source_path"
echo "symlink $rel_path" >> install.sh
