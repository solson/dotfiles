# ~/.profile: Executed by the command interpreter for login shells.
#
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.
# See /usr/share/doc/bash/examples/startup-files for examples. The files are
# located in the bash-doc package.

if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# Set PATH so it includes user's private bin if it exists.
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# Set the GPG_AGENT_INFO and SSH_AUTH_SOCK environment variables in i3.
if [ "$0" = "/usr/sbin/lightdm-session" -a "$DESKTOP_SESSION" = "i3" ]; then
  export $(gnome-keyring-daemon -s)
fi
