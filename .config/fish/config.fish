################################################################################
# Environment
################################################################################

set -x DEVKITPRO "$HOME/code/nds/devkitpro"
set -x DEVKITARM "$DEVKITPRO/devkitARM"
set -x R4 "/media/$USER/R4"

set extra_paths \
  ~/bin \
  ~/.bin \
  ~/.cargo/bin \
  ~/.perl6/bin

for path in $extra_paths
  if test -d $path
    set PATH $PATH $path
  end
end

# Remove duplicates in path.
set PATH (ruby -e 'puts ARGV[0].split(":").uniq.join(":")' "$PATH")

# Silence warnings from Gtk applications about the accessibility bus.
set -x NO_AT_BRIDGE 1

# Use a custom man page viewer.
set -x MANPAGER 'nvim -c "set ft=man" -'

# Tell SSH where the ssh-agent socket is.
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent

################################################################################
# Misc functions
################################################################################

alias bash 'env DONT_EXEC_FISH=1 bash'
alias o 'xdg-open'
alias ll 'ls -lh'
alias la 'ls -A'
alias dfh 'df -h /{data{2,},} --output=size,used,avail,pcent,target'

function ls
  set -l options
  if isatty stdout
    set options --color=always --format=across --group-directories-first
  end
  command ls $options $argv | filter-nix-paths
end

function mkcd -a dir
  mkdir -p $dir
  cd $dir
end

################################################################################
# Nix functions
################################################################################

alias nb 'nix-build --no-out-link "<nixpkgs>" -A'
alias nr 'nix repl "$HOME/.nix-repl.nix" "<nixpkgs>"'

function nbins -a pkg
  set -l store_path (nbb $pkg)
  and ll $store_path/bin/
end

function nwhich
  for arg in $argv
    set -l path (which $arg)
    and set path (readlink $path)
    and echo $path | filter-nix-paths
  end
end

# Usage:
#   nu
#   nu a b
#   nu a b -- foo bar
# Equivalent:
#   nix-shell -p
#   nix-shell -p a b
#   nix-shell -p a b --run 'foo bar'
function nu
  if set -l split (contains -i -- -- $argv)
    set -l before (math $split - 1)
    set -l after  (math $split + 1)
    set -q argv[$before]; and set -l packages $argv[1..$before]
    set -q argv[$after];  and set -l command  $argv[$after..-1]
    nix-shell -p $packages --run "$command"
  else
    nix-shell -p $argv
  end
end

# Usage:
#   nx foo -b baz
# Equivalent:
#   nu foo -- foo -b baz
function nx
  nix-shell -p $argv[1] --run "$argv"
end

# Abbreviate nix store paths:
#   /nix/store/abcdefghijklmnopqrstuvwxyz012345-foo/bar
# becomes
#   /ns/abcdefg*-foo/bar
function filter-nix-paths
  ruby -pe '
    $_.gsub!(%r"/nix/store/(.*?)([a-z0-9]{32})-") do
      "/ns/#{$1}#{$2[0..6]}*-"
    end

    $_.gsub!(/Dec 31  1969 /, "")
  '
end

################################################################################
# Rust aliases
################################################################################

alias cb 'cargo build -j8'
alias cr 'cargo run -j8'
alias ct 'cargo test -j8'
alias cbr 'cb --release'
alias crr 'cr --release'

################################################################################
# Keybindings
################################################################################

# Set C-c to simply clear the command line.
bind \cc 'commandline ""'

################################################################################
# Prompt and title
################################################################################

set fish_prompt_first 1
function fish_prompt
  set -l last_status $status

  if [ $fish_prompt_first = 0 ]
    echo
  else
    set fish_prompt_first 0
  end

  # Clear the current line with a terminal escape code to avoid drawing issues
  # with Alt-{Left,Right} working directory history commands.
  echo -en '\e[2K'

  set_color brblack
  echo -n '['
  set_color $fish_color_cwd
  echo -n (prompt_pwd)

  if set -q SSH_TTY
    set_color brblack
    echo -n "|"
    set_color brcyan
    echo -n (prompt_hostname)
  end

  if echo "$PATH" | grep -q /nix/store
    set_color brblack
    echo -n "|"
    set_color magenta
    echo -n "nix"
  end

  set_color brblack
  __fish_git_prompt "|%s"

  # If the last command took longer than 5 seconds, print its execution time.
  if [ "$CMD_DURATION" -gt 5000 ]
    set_color brblack
    echo -n "|"
    set_color yellow
    echo -n (format-duration $CMD_DURATION)
  end

  if [ $last_status != 0 ]
    set_color brblack
    echo -n "|"
    set_color red
    echo -n $last_status
  end

  set_color brblack
  echo -n ']'
  echo

  if [ $last_status != 0 ]
    set_color red
  else
    set_color normal
  end
  echo -n '> '
  set_color normal
end

# function fish_right_prompt
# end

set __fish_git_prompt_char_stateseparator ''
set __fish_git_prompt_describe_style branch
set __fish_git_prompt_showcolorhints 1
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_showstashstate 1
set __fish_git_prompt_showuntrackedfiles 1
set __fish_git_prompt_showupstream informative

function fish_title
  echo (prompt_pwd) : $_
end

################################################################################
# Misc
################################################################################

# Disable startup message.
set fish_greeting ""

################################################################################
# Colours
################################################################################

set fish_color_command yellow
set fish_color_cwd brblue
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
  /usr/share/autojump/autojump.fish \
  ~/.config/fish/autojump.fish

for autojump_script in $autojump_scripts
  if [ -f $autojump_script ]
    . $autojump_script
  end
end

################################################################################
# Work-specific configuration
################################################################################

set -l work_config  ~/.dotfiles-at-work/config-work.fish
if test -f $work_config
  . $work_config
end
