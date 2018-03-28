# If not running interactively, stop here.
case $- in
  *i*) ;;
    *) return;;
esac

# Exec fish unless DONT_EXEC_FISH is defined. Define it before execing so
# starting bash in fish won't exec fish again. Additionally, don't exec fish if
# bash is running inside nix-shell.
if [ -z "$DONT_EXEC_FISH" -a -z "$IN_NIX_SHELL" ]; then
  export DONT_EXEC_FISH=1
  command -v fish >/dev/null 2>&1 && exec fish "$@"
fi

PS1='\n\[\033[01;34m\]bash:\w\[\033[00m\]\$ '
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
