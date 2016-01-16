#!/bin/bash
set -e

dconfdir="/org/gnome/terminal/legacy/profiles:"
profile_id="$(dconf list /org/gnome/terminal/legacy/profiles:/ | sed -e 's/\///g' -n -e '1p')"
profile_path="$dconfdir/$profile_id"

# Font.
dconf write "$profile_path/use-system-font" "false"
dconf write "$profile_path/font" "'Terminess Powerline 10'"

# Custom startup command.
dconf write "$profile_path/use-custom-command" "true"
dconf write "$profile_path/custom-command" "'env COLORTERM=gnome-terminal fish'"


## Modified Jellybeans colors for gnome-terminal (with dconf).

palette="['#888888888888', '#cfcf6a6a4c4c', '#8787afaf5f5f', '#fafad0cf7a79', '#8181a3a3eded', '#c6c5b6b6eeee', '#8f8fbfbedcdc', '#e8e8e8e8d3d3', '#888888888888', '#cfcf6a6a4c4c', '#8787afaf5f5f', '#fafad0cf7a79', '#8181a3a3eded', '#c6c5b6b6eeee', '#8f8fbfbedcdc', '#e8e8e8e8d3d3']"
foreground_color="'#e8e8d3'"
background_color="'#151515'"
bold_color="'#adadad'"

# Color palette.
dconf write "$profile_path/palette" "$palette"

# Foreground, background and highlight color.
dconf write "$profile_path/foreground-color" "$foreground_color"
dconf write "$profile_path/background-color" "$background_color"
dconf write "$profile_path/bold-color" "$bold_color"

# Profile does not use theme colors.
dconf write "$profile_path/use-theme-colors" "false"

# Highlighted color different from foreground color.
dconf write "$profile_path/bold-color-same-as-fg" "false"
