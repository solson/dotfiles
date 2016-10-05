# Set the SSH agent directory to a stable location rather than a random
# temporary directory.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"

NIX_SH="$HOME/.nix-profile/etc/profile.d/nix.sh" 
[[ -f "$NIX_SH" ]] && source "$NIX_SH"
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.bin" ]] && PATH="$HOME/.bin:$PATH"
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
