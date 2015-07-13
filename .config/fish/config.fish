# Main fish configuration

## Environment

set -x DEVKITPRO "$HOME/code/nds/devkitpro"
set -x DEVKITARM "$DEVKITPRO/devkitARM"
set -x R4 "/media/$USER/R4"


## Basics

set fish_prompt_first 1
function fish_prompt
  set -l last_status $status

  if [ $fish_prompt_first = 0 ]
    echo
  else
    set fish_prompt_first 0
  end

  set_color $fish_color_cwd
  echo -n (prompt_pwd)

  if [ $last_status != 0 ]
    set_color red
  else
    set_color normal
  end
  echo -n '> '
  set_color normal
end

function fish_title
  echo $_ (prompt_pwd)
end

# Disable startup message.
set -e fish_greeting


## Colours

set fish_color_command yellow
set fish_color_cwd blue
set fish_color_error red
set fish_color_param white
set fish_color_quote green
set fish_color_redirection green
set fish_color_search_match
set fish_color_valid_path


## Aliases

alias node 'env NODE_NO_READLINE=1 rlwrap -pGreen node'
alias cr 'cargo run'
alias o 'xdg-open'
alias ls 'ls --color=auto'
alias ll 'ls -l'
alias la 'ls -A'
alias lh 'ls -lh'

function mkcd
  mkdir -p $argv[1]
  cd $argv[1]
end

function mkproj
  if [ (count $argv) -ne 1 ]
    echo "usage: mkproj <name>"
    return 1
  end

  mkcd ~/code/$argv[1]
  hub init -g
end

alias apti  'sudo apt-get install'
alias aptr  'sudo apt-get remove'
alias aptrr 'sudo apt-get purge'
alias aptar 'sudo apt-get autoremove'
alias aptu  'sudo apt-get update'
alias aptg  'sudo apt-get upgrade'
alias apts  'apt-cache search'
alias aptw  'apt-cache show'

function aptbins
  dpkg -L $argv[1] | grep --color=none bin/
end


## Autojump

set -l autojump_script ~/.autojump/share/autojump/autojump.fish
if [ -f $autojump_script ]
  source $autojump_script
end


## TTY casting commands

function start-ttycast
  if [ ! -p ~/.ttycast/pipe ]
    echo >&2 "Please run serve-ttycast first."
    return 1
  end

  set -l columns (cat ~/.ttycast/columns)
  set -l lines   (cat ~/.ttycast/lines)
  resize -s $lines $columns
  reset
  ttyrec ~/.ttycast/pipe
end

function serve-ttycast
  if [ (count $argv) -ne 2 ]; then
    echo >&2 "usage: serve-ttycast <columns> <lines>"
    return 1
  end

  set -l port    12345
  set -l columns $argv[1]
  set -l lines   $argv[2]

  mkdir -p ~/.ttycast
  rm -f ~/.ttycast/*
  echo $columns > ~/.ttycast/columns
  echo $lines   > ~/.ttycast/lines
  mkfifo ~/.ttycast/pipe
  echo "Serving at $columns""x$lines on http://vps.solson.me:$port/"
  ttyplay -n ~/.ttycast/pipe | ssh vps PORT=$port ttycast -r $lines -c $columns
  # Clean up once ttycast ends.
  rm -f ~/.ttycast/*
end
