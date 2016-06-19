# If not running interactively, stop here.
case $- in
  *i*) ;;
    *) return;;
esac

# Exec fish unless DONT_EXEC_FISH is defined. In fish, I alias bash to
# `env DONT_EXEC_FISH=1 bash`. Additionally, don't exec fish if bash is running
# inside nix-shell.
if [ -z "$DONT_EXEC_FISH" -a -z "$IN_NIX_SHELL" ]; then
  exec fish "$@"
fi

PS1='\n\[\033[01;34m\]bash:\w\[\033[00m\]\$ '
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
