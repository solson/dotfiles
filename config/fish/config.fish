################################################################################
# Misc functions
################################################################################

function bash
  env DONT_EXEC_FISH=1 bash $argv
end
alias dfh 'df -h /{data{2,},} --output=size,used,avail,pcent,target'
alias la 'ls -A'
alias ll 'ls -lh'
alias ffmpeg 'ffmpeg -hide_banner'
alias ffprobe 'ffprobe -hide_banner'
alias o 'xdg-open'
alias rg 'rg -i'

function v -w nvim
  if not set -q argv[1]
    nvim
    return $status
  end
  if not string match -rq '^(?<path>[^:]*)(:(?<line>\d+)(:(?<col>\d+))?)?$' $argv[1]
    echo "bad path '$argv[1]', expected <path>[:<line>[:<col>]]"
    return 1
  end
  nvim '+normal '$line'gg'$col'|' $path $argv[2..]
end

function less
  env LESS=R less $argv
end

# Useful for `deno types | lessb -lts`, for example (to view output as
# syntax-highlighted TypeScript).
function lessb -w bat
  bat $argv | less -R
end

function ls
  set -l options
  if isatty stdout
    set options --color=always --format=across --group-directories-first
  end
  command ls $options $argv
end

function mkcd -a dir
  mkdir -p $dir
  cd $dir
end

function acd -a archive -w aunpack
  set -l tmp (mktemp /tmp/aunpack.XXXXXXXXXX)
  aunpack --quiet --save-outdir=$tmp $argv
  set -l dir (cat $tmp)
  [ $dir != '' -a -d $dir ]; and cd $dir
  rm -f $tmp
end

alias t 'broot -c :pt --height (math (tput lines) - 3)'

function fdt -w fd
  fd $argv | as-tree
end

################################################################################
# Nix functions
################################################################################

alias nb 'nix-build --no-out-link "<nixpkgs>" -A'
alias nr 'nix repl "$XDG_CONFIG_HOME/nix/nix-repl.nix" "<nixpkgs>"'

function nt -w tree -a pkg
  set -e argv[1]
  set -l store_path (nb $pkg)
  and tree $store_path $argv
end

function nbr -w br -a pkg
  set -e argv[1]
  set -l store_path (nb $pkg)
  and br $argv $store_path
end

function nbins -a pkg
  set -l store_path (nb $pkg)
  and echo $store_path/bin
  and ll $store_path/bin/
end

function nwhich
  for arg in $argv
    readlink -f (which $arg)
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

function nf
  nix-shell -p $argv --run fish
end

# Usage:
#   nx foo -b baz
# Equivalent:
#   nu foo -- foo -b baz
function nx
  nix-shell -p $argv[1] --run "$argv"
end

function nsrc -a pkg
  acd (nb $pkg.src)
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
    $_.gsub!(/Jan  1  1970 /, "")
  '
end

################################################################################
# Rust aliases
################################################################################

alias cb 'cargo build'
alias cr 'cargo run'
alias ct 'cargo test'
alias cbr 'cargo build --release'
alias crr 'cargo run --release'

################################################################################
# youtube-dl aliases
################################################################################

alias yt youtube-dl
alias yta 'yt --config-location ~/.config/youtube-dl/config-archival'
alias ytm 'yt --config-location ~/.config/youtube-dl/config-music'
alias ytmp3 'yt --config-location ~/.config/youtube-dl/config-mp3'
alias ytn 'yt --format="bestvideo[height<=?1440]+bestaudio/best"'

################################################################################
# Keybindings
################################################################################

# Set C-c to simply clear the command line.
bind \cc 'commandline ""'

################################################################################
# Prompt and title
################################################################################

# Keep track of /nix/store paths in PATH.
function update_nix_shell_pkg_list -v PATH
  set -l nix_paths
  for path in $PATH
    string match -q '/nix/store/*' $path || continue
    set -a nix_paths $path
  end

  if test (count $nix_paths) -eq 0
    set -gu NIX_SHELL_PKGS
  else
    set -gu NIX_SHELL_PKGS (nix show-derivation $nix_paths |
      jq -r 'to_entries[].value.env | .pname // (.name | split("-")[0])')
  end

  # Check if the entire set of nixpkgs stdenv packages is present, and if so,
  # abbreviate it.
  set -l stdenv gnumake bzip2 gzip bash xz gcc gnused coreutils gnutar \
    patchelf gcc-wrapper gnugrep bash gawk diffutils patch findutils glibc \
    binutils-wrapper binutils

  set -l pkgs_without_stdenv $NIX_SHELL_PKGS
  for pkg in $stdenv
    set -l i (contains -i $pkg $pkgs_without_stdenv) || return
    set -e pkgs_without_stdenv[$i]
  end

  set -gu NIX_SHELL_PKGS «stdenv» $pkgs_without_stdenv
end
update_nix_shell_pkg_list

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

  set -l prompt_bgcolor 262626
  set_color -b $prompt_bgcolor

  set_color $prompt_bgcolor
  echo -n '['
  set_color brblue
  echo -n (solson_prompt_pwd)

  if set -q SSH_TTY
    set_color $prompt_bgcolor
    echo -n '|'
    set_color brcyan
    echo -n (prompt_hostname)
  end

  if test (count $NIX_SHELL_PKGS) -gt 0
    set -l pkgs $NIX_SHELL_PKGS
    set -l output

    if set -l i (contains -i «stdenv» $pkgs)
      set -e pkgs[$i]
      set -a output «stdenv»
    end

    if test (count $pkgs) -gt 3
      set -a output (count $pkgs)…
    else
      set -a output $pkgs
    end

    set_color $prompt_bgcolor
    echo -n '|'
    set_color brmagenta
    echo -n "{$output}"
  end

  # FIXME(solson): This is a ridiculous hack to make fish_git_prompt not reset
  # the background color.
  if not set -q ___fish_git_prompt_init
    fish_git_prompt > /dev/null
    set -g ___fish_git_prompt_color_branch_done ''
    set -g ___fish_git_prompt_color_branch_detached_done ''
    set -g ___fish_git_prompt_color_dirtystate_done ''
    set -g ___fish_git_prompt_color_stagedstate_done ''
    set -g ___fish_git_prompt_color_stashstate_done ''
    set -g ___fish_git_prompt_color_untrackedfiles_done ''
    set -g ___fish_git_prompt_color_upstream_done ''
  end
  set_color $prompt_bgcolor
  fish_git_prompt "|%s"

  set_color $prompt_bgcolor
  echo -n ']'
  set_color normal

  # If the last command took longer than 5 seconds, print its execution time.
  if [ "$CMD_DURATION" -gt 5000 ]
    echo -n ' '
    set_color yellow
    echo -n (format-duration $CMD_DURATION)
  end

  if [ $last_status != 0 ]
    echo -n ' '
    set_color red
    echo -n $last_status
  end

  echo
  set_color brblack
  echo -n '> '
  set_color normal
end

set __fish_git_prompt_describe_style default
set __fish_git_prompt_showcolorhints 1
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_showstashstate 1
set __fish_git_prompt_showuntrackedfiles 1
set __fish_git_prompt_showupstream informative

set __fish_git_prompt_char_dirtystate '~'
set __fish_git_prompt_char_invalidstate '✖'
set __fish_git_prompt_char_stagedstate '●'
set __fish_git_prompt_char_stashstate '⚑'
set __fish_git_prompt_char_stateseparator ''
set __fish_git_prompt_char_untrackedfiles '?'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'
set __fish_git_prompt_char_upstream_diverged '↕'

set __fish_git_prompt_color_dirtystate red
set __fish_git_prompt_color_invalidstate brred
set __fish_git_prompt_color_stagedstate green
set __fish_git_prompt_color_stashstate yellow
set __fish_git_prompt_color_untrackedfiles red
set __fish_git_prompt_color_upstream white

function fish_title
  echo (solson_prompt_pwd)" : $_"
end

function solson_prompt_pwd
  string replace -rf '^/mut/platform/?' // $PWD
  or prompt_pwd
end

################################################################################
# Misc
################################################################################

# Disable startup message.
set fish_greeting ""

# Just use regular man pages instead of Fish's weird postprocessing.
alias __fish_print_help man

# Screen clearing that handles my newline-between-prompts setup better.
bind \cl 'set fish_prompt_first 1; command clear -x; commandline -f repaint'
alias clear 'set fish_prompt_first 1; command clear'

################################################################################
# Colours
################################################################################

# Enable 24-bit color in Konsole.
if set -q KONSOLE_VERSION
  set fish_term24bit 1
end

set fish_color_autosuggestion brblack
set fish_color_command brmagenta --bold
set fish_color_comment brblack
set fish_color_cwd brblue
set fish_color_end brblack
set fish_color_error red
set fish_color_escape brblue
set fish_color_history_current --bold
set fish_color_normal normal
set fish_color_operator bryellow
set fish_color_param normal
set fish_color_quote brblue
set fish_color_redirection brgreen
set fish_color_search_match ''
set fish_color_valid_path ''
set fish_pager_color_description bryellow
set fish_pager_color_prefix ''
set fish_pager_color_progress brwhite

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
# Direnv
################################################################################

direnv hook fish | source

################################################################################
# Fzf - https://github.com/junegunn/fzf
################################################################################

set -x FZF_CTRL_T_COMMAND 'fd --type f . $dir'
set -x FZF_CTRL_T_OPTS '--preview "bat {} --line-range :500"'
set -x FZF_ALT_C_COMMAND 'fd --type d . $dir'
set -x FZF_ALT_C_OPTS '--preview "tree -C {} | head -200"'
