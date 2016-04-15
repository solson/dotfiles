################################################################################
# Environment
################################################################################

set -x DEVKITPRO "$HOME/code/nds/devkitpro"
set -x DEVKITARM "$DEVKITPRO/devkitARM"
set -x R4 "/media/$USER/R4"

# PATH
set extra_paths \
  ~/bin \
  /usr/lib/ccache \
  ~/.cargo/bin

for path in $extra_paths
  if [ -d $path ]
    set fish_user_paths $fish_user_paths $path
  end
end

# Silence warnings from Gtk applications about the accessibility bus.
set -x NO_AT_BRIDGE 1

# Use a custom man page viewer.
set -x MANPAGER manpager

# Tell SSH where the ssh-agent socket is.
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent

################################################################################
# CMPT 442 Aliases
################################################################################

alias 442mk 'make SML=/usr ARCH=x86-linux'

function 442run
  442mk compile; and echo; and sml @SMLload=./sources $argv
end

function 442test
  442run $argv[1..-2] (echo $argv[-1] | psub)
end

################################################################################
# Misc Aliases
################################################################################

alias bash 'env DONT_EXEC_FISH=1 bash'
alias node 'env NODE_NO_READLINE=1 rlwrap -pGreen node'
alias racket 'rlwrap racket'
alias o 'xdg-open'
alias ls 'ls --color=auto'
alias ll 'ls -l'
alias la 'ls -A'
alias lh 'ls -lh'

function lt
  if test -f .gitignore
    set -l ignores (cat .gitignore)
    eval tree -C '-I '$ignores $argv
  end
end

function mkcd
  mkdir -p $argv[1]
  cd $argv[1]
end

################################################################################
# Rust aliases
################################################################################

alias cb 'cargo build -j8'
alias cr 'cargo run -j8'
alias ct 'cargo test -j8'

function rag-def
  set -l name $argv[1]
  set -e argv[1]

  ag "^\s*(pub\s*)?(type|struct|enum|trait|flags|fn|macro_rules!|static|const|mod)\s+$name\b" \
    $argv
end

function miri
  if [ -z $MIRI_TOOLCHAIN ]
    set MIRI_TOOLCHAIN x86_64-unknown-linux-gnu
  end
  set -l toolchain nightly-$MIRI_TOOLCHAIN
  echo "Using Rust toolchain: $toolchain"
  rustup run $toolchain cargo run \
    --target $MIRI_TOOLCHAIN \
    -- \
    --sysroot $HOME/.multirust/toolchains/$toolchain \
    $argv
end

function print-mir -a file func
  rustup run nightly rustc \
    --crate-type lib \
    -Z unstable-options \
    --unpretty mir=$func \
    $file
end

################################################################################
# Apt aliases
################################################################################

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

################################################################################
# Nix aliases
################################################################################

alias nix-repl 'nix-repl "$HOME/.nix-repl.nix"'

function nixs
  # Put .* between each argv string.
  set -l pattern (printf "%s\n" $argv | paste -sd,)
  nix-env -qaP ".*$pattern.*" --description
end

################################################################################
# Prompt and title
################################################################################

set fish_prompt_first 1
set hostname (hostname -s)
function fish_prompt
  set -l last_status $status

  if [ $fish_prompt_first = 0 ]
    echo
  else
    set fish_prompt_first 0
  end

  # If the last command took longer than 5 seconds, print its execution time.
  if [ "$CMD_DURATION" -gt 5000 ]
    set_color yellow
    echo -n "Execution time: "
    format-duration $CMD_DURATION
  end

  if [ $hostname != "neutron" ]
    set_color green
    echo -n $hostname
    set_color normal
    echo -n :
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

function fish_right_prompt
  set_color yellow
  __fish_git_prompt '%s'
end

function fish_title
  echo $_ (prompt_pwd)
end

################################################################################
# Misc
################################################################################

# Disable startup message.
set -e fish_greeting

################################################################################
# Colours
################################################################################

set fish_color_command yellow
set fish_color_cwd blue
set fish_color_error red
set fish_color_param white
set fish_color_quote green
set fish_color_redirection green
set fish_color_search_match
set fish_color_valid_path

################################################################################
# Autojump
################################################################################

set -l autojump_scripts \
  ~/.autojump/share/autojump/autojump.fish \
  /usr/share/autojump/autojump.fish

for autojump_script in $autojump_scripts
  if [ -f $autojump_script ]
    source $autojump_script
  end
end
