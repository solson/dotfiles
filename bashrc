# shellcheck shell=bash

################################################################################
# Environment variables
################################################################################

# Build the PATH from scratch, saving the original in _PATH.
[[ -z "$_PATH" ]] && export _PATH=$PATH
PATH=/run/wrappers/bin:/run/current-system/sw/bin:"$HOME/.local/bin"

# Set the SSH agent directory to a stable location rather than a random
# temporary directory.
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent

[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME=$HOME/.config
[[ -z "$XDG_CACHE_HOME" ]] && export XDG_CACHE_HOME=$HOME/.cache
[[ -z "$XDG_DATA_HOME" ]] && export XDG_DATA_HOME=$HOME/.local/share

################################################################################
# Force XDG Base Directories
################################################################################

# Amazon Web Services CLI
export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config

# Cargo
export CARGO_HOME=$XDG_DATA_HOME/cargo

# Curl
export CURL_HOME=$XDG_CONFIG_HOME/curl

# Dungeon Crawl Stone Soup
export CRAWL_DIR=$XDG_DATA_HOME/crawl/ # Trailing / is required.

# Elan (https://github.com/Kha/elan)
export ELAN_HOME=$XDG_DATA_HOME/elan

# GTK 2
export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc

# Interactive Ruby Shell
export IRBRC=$XDG_CONFIG_HOME/irb/irbrc

# leanproject (https://github.com/leanprover-community/mathlib-tools)
export MATHLIB_CACHE_DIR=$XDG_CACHE_HOME/mathlib

# Less
export LESSHISTFILE=- # Disable entirely.

# Mednafen
export MEDNAFEN_HOME=$XDG_CONFIG_HOME/mednafen

# Node.js
export NODE_REPL_HISTORY=$XDG_DATA_HOME/node_repl_history

# NVIDIA CUDA
export CUDA_CACHE_PATH=$XDG_CACHE_HOME/nv

# GNU Readline
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc

# rlwrap
export RLWRAP_HOME=$XDG_DATA_HOME/rlwrap

# Rustup
export RUSTUP_HOME=$XDG_DATA_HOME/rustup

# Spacemacs
export SPACEMACSDIR=$XDG_CONFIG_HOME/spacemacs

# SQLite
export SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history

# XCompose
export XCOMPOSEFILE=$XDG_CONFIG_HOME/X11/XCompose
export XCOMPOSECACHE=$XDG_CACHE_HOME/X11/compose-cache

################################################################################
# Interactive
################################################################################

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
