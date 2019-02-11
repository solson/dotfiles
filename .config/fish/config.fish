################################################################################
# Environment
################################################################################

set -x DEVKITPRO "$HOME/code/nds/devkitpro"
set -x DEVKITARM "$DEVKITPRO/devkitARM"
set -x R4 "/media/$USER/R4"

# PATH
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

function lt
  if test -f .gitignore
    set -l ignores (cat .gitignore)
    eval tree -C '-I '$ignores $argv
  end
end

function mkcd -a dir
  mkdir -p $dir
  cd $dir
end

function with -a var_name value
  set -l cmd $argv[3..-1]
  set -l saved $$var_name
  set -x $var_name $value
  eval $argv[3] \"$argv[4..-1]\"
  set -x $var_name $saved
end

################################################################################
# Nix functions
################################################################################

alias nb nix-build
alias nbb 'nix-build --no-out-link "<nixpkgs>" -A'
alias nr 'nix repl "$HOME/.nix-repl.nix" "<nixpkgs>"'
alias nre 'sudo nixos-rebuild switch'

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
#   nx foo -- foo -b baz
function nx
  nix-shell -p $argv[1] --run "$argv"
end

function nur
  set_color red
  echo '"nur" is deprecated, use "nx"'
  set_color normal
  nx $argv
end

function nml
  if set -l split (contains -i -- -- $argv)
    set -l before (math $split - 1)
    set -l after  (math $split + 1)
    set -q argv[$before]; and set -l packages $argv[1..$before]
    set -q argv[$after];  and set -l command  $argv[$after..-1]
    nix-shell -p "(with ocamlPackages_4_02; [utop findlib $packages])" --run "$command"
  else
    nix-shell -p "(with ocamlPackages_4_02; [utop findlib $argv])"
  end
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

function rag-def
  set -l name $argv[1]
  set -e argv[1]

  ag "^[^({\n]*(type|struct|enum|trait|flags|fn|macro_rules!|static|const|mod)\s+$name\b" \
    $argv
end

function print-mir -a file func
  rustc \
    --crate-name print_mir \
    --crate-type lib \
    -Z unstable-options \
    --unpretty mir=$func \
    $file
end

function mir -a code
  print-mir (echo "pub fn mir$code" | psub) mir
end

function miri -a code
  miri-mini "fn main() { $argv }"
end

function miri-opt -a code
  miri-mini-opt "fn main() { $argv }"
end

function miri-mini -a code
  cargo run --bin miri -- --crate-name m -Z mir-opt-level=3 (echo $code | psub)
end

function miri-mini-opt -a code
  cargo run --release --bin miri -- --crate-name m -Z mir-opt-level=3 (echo $code | psub)
end

################################################################################
# Prompt and title
################################################################################

set fish_prompt_first 1
set hostname_ (uname -n | cut -d. -f1)
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

  if [ -n "$IN_NIX_SHELL" ]
    set_color magenta
    echo -n nix:
    set_color normal
  end

  if [ $hostname_ != "conway" ]
    set_color green
    echo -n $hostname_
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
  __fish_git_prompt '%s'
end

set __fish_git_prompt_char_stateseparator ''
set __fish_git_prompt_describe_style branch
set __fish_git_prompt_showcolorhints 1
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_showstashstate 1
set __fish_git_prompt_showuntrackedfiles 1
set __fish_git_prompt_showupstream informative

function fish_title
  echo $_ (prompt_pwd)
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
