# Set the GPG_AGENT_INFO and SSH_AUTH_SOCK environment variables in i3.
if [ "$0" = "/usr/sbin/lightdm-session" -a "$DESKTOP_SESSION" = "i3" ]; then
  export $(gnome-keyring-daemon -s)
fi

# Set the SSH agent directory to a stable location rather than a random
# temporary directory.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"

NIX_SH="$HOME/.nix-profile/etc/profile.d/nix.sh" 
[[ -f "$NIX_SH" ]] && source "$NIX_SH"
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.bin" ]] && PATH="$HOME/.bin:$PATH"
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
