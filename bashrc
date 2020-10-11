# shellcheck shell=bash

# Set the SSH agent directory to a stable location rather than a random
# temporary directory.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"

# If not running interactively, stop here.
case $- in
  *i*) ;;
  *) return;;
esac

# Exec fish unless DONT_EXEC_FISH is defined. In fish, I alias bash to
# `env DONT_EXEC_FISH=1 bash`. Additionally, don't exec fish if bash is running
# inside nix-shell.
if [[ -z "$DONT_EXEC_FISH" && -z "$IN_NIX_SHELL" ]]; then
  command -v fish >/dev/null 2>&1 && exec fish "$@"
fi

PS1='\n\[\033[01;34m\]bash:\w\[\033[00m\]\$ '
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
