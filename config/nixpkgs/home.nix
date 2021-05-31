{ config, lib, pkgs, ... }:

let
  inherit (builtins) listToAttrs;
  inherit (lib) nameValuePair;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  # TODO: Move home.nix to the repository root.
  dotfilesRoot = toString ../..;

  # wrap = pkg: name: pkgs.runCommand name {} ''
  #   mkdir $out
  #   ln -s ${pkg}/* $out/
  #   rm $out/bin
  #   mkdir $out/bin
  #   ln -s ${pkg}/bin/truffleruby $out/bin/
  # '';
in

{
  home.packages = with pkgs; [
    # Media
    aria # For youtube-dl. TODO: interpolate directly into youtube-dl config
    (beets.override {
      enableAlternatives = true;
      enableCopyArtifacts = true;
    })
    ffmpeg
    imagemagick
    mediainfo
    youtube-dl

    # GUI utilities
    # TODO: move more stuff over from NixOS config if they work well in home-manager
    screenkey

    # CLI utilities
    # dijo # TODO: try it out
    # just # TODO: try replacing ~/Projects/etc-nixos/shannon scripts with this
    # procs # TODO: try it out
    # rclone # TODO: try it out
    # sd # TODO: try it out
    # zoxide # TODO: try it out, replace autojump
    as-tree
    asciinema
    atool
    autojump
    bat
    broot
    curl
    du-dust
    elvish
    fd
    file
    fish
    fzf
    hexyl
    htop
    jq
    litecli # for sqlite
    megatools
    moreutils # vidir, ts
    ncdu
    neovim
    noti # TODO: try it out
    pstree
    renameutils # imv, icp
    rink
    ripgrep
    rlwrap
    rsync
    tokei
    tree
    unrar
    unzip
    xclip
    xxd

    # Programming
    babashka
    cargo-asm
    cargo-edit
    cargo-watch
    direnv
    deno
    emacs # for agda. TODO: investigate vim and vscode extensions
    ghc
    go
    julia_16-bin
    llvmPackages_latest.clang
    nodejs
    python3
    rakudo
    ruby_3_0
    rustup
    shellcheck
    watchexec

    # Git
    # delta # TODO: try it out, replace diff-so-fancy
    # git-annex # TODO: try it out
    # git-annex-remote-rclone
    # git-annex-utils
    # gitui/lazygit # TODO: try them out
    diff-so-fancy
    gh
    gist
    git-absorb
    git-revise
    gitFull
    tig

    # Nix
    # TODO: make a clone of https://github.com/Shopify/comma/blob/master/%2C
    nix-index
    nix-tree
    patchelf

    # Networking
    # TODO: create a package for https://github.com/dreibh/subnetcalc
    curlie
    dnsutils # dig
    dogdns
    ipcalc # CIDR, IPv4-only, colorful
    ipv6calc
    mtr
    nmap
    sipcalc # CIDR, IPv4/IPv6, non-colorful
    socat
    tcpdump
    traceroute
    whois

    # Security
    # firejail # TODO: try it out
    gnupg
    yubikey-manager

    # Debugging/tracing
    gdb
    linuxPackages.bpftrace # TODO: try it out
    linuxPackages.perf
    lsof
    ltrace
    strace

    # Hardware
    pciutils # lspci
    usbutils # lsusb
  ];

  # TODO: replace mutable files with immutable store paths where it makes sense
  home.file =
    let
      files = [
        "bash_profile"
        "bashrc"
        "config/X11"
        "config/bat"
        "config/broot"
        "config/fish"
        "config/git"
        "config/irb"
        "config/nix"
        "config/nixpkgs"
        "config/nvim"
        "config/readline"
        "local/bin/format-duration"
        "local/bin/notify-run"
        "local/share/konsole/VSCode-WIP.colorscheme"
      ];
      mkMutSymlink = file: nameValuePair ".${file}" {
        source = mkOutOfStoreSymlink "${dotfilesRoot}/${file}";
      };
      mutSymlinks = listToAttrs (map mkMutSymlink files);
      symlinks = {
        # Repurpose complete.oga as my terminal bell sound.
        ".local/share/sounds/freedesktop/stereo/bell.oga".source =
          "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga";
      };
    in
      symlinks // mutSymlinks;

  programs.man = {
    enable = true;
    generateCaches = true;
  };

  programs.home-manager.enable = true;
  home.username = "scott";
  home.homeDirectory = "/home/scott";
  home.stateVersion = "21.05";
}
