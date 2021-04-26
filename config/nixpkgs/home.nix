{ config, pkgs, ... }:

let
  # symlinkBinsPrefixed = prefix: pkg: bins:
  #   pkgs.runCommand "${pkg.name}-bins" {} ''
  #     mkdir -p $out/bin
  #     ${map (bin: "ln -s ${pkg}/bin/${bin} $out/bin/${bin}\n" bins}
  #   '';

  # symlinkBins = symlinkBinsPrefixed "";

  # graalBins1 = symlinkBins pkgs.graalvm11-ce [ "native-image" ];
  # graalBins2 = symlinkBinsPrefixed "graal-" pkgs.graalvm11-ce [ "native-image" ];
in

{
  home.packages = with pkgs; [
    # TODO: Make my own version of https://github.com/Shopify/comma/blob/master/%2C
    denoBins.latest # TODO: move denoBins overlay into home-manager config
    diffoscope
    nix-tree # https://github.com/utdemir/nix-tree
    noti # https://github.com/variadico/noti
    yq-go # https://github.com/mikefarah/yq

    # TODO: Moved over from system configuration. To be sorted.
    aria # TODO: do i need this because something else uses it?
    as-tree
    asciinema
    atool
    autojump
    babashka
    bat
    (beets.override {
      enableAlternatives = true;
      enableCopyArtifacts = true;
    })
    broot
    cargo-asm
    cargo-edit
    cargo-watch
    denoBins.latest
    direnv
    diskus
    dnsutils # dig
    emacs
    fd
    file
    # firejail # TODO: try it out
    fzf
    ghc
    gist
    # git-revise # TODO: try it out
    # git-series # TODO: try it out
    gitAndTools.diff-so-fancy
    # gitAndTools.git-annex # TODO: try it out
    # gitAndTools.git-annex-remote-rclone
    # gitAndTools.git-annex-utils
    gitAndTools.hub # TODO: try alternative `gh`
    go
    hexyl
    httpie
    imagemagick
    jq
    julia
    just # TODO: try replacing ~/Projects/etc-nixos/shannon scripts with this
    linuxPackages.bpftrace # TODO: try it out
    linuxPackages.perf
    litecli # for sqlite
    lsof
    ltrace
    mediainfo
    moreutils # vidir, ts
    mtr
    ncdu
    nix-index
    nodejs
    patchelf
    pciutils # lspci
    pstree
    python3
    racket
    rakudo
    # rclone # TODO: try it out
    renameutils # imv, icp
    rink
    ripgrep # rg
    rlwrap
    rsync
    ruby
    rustup
    shellcheck
    strace
    tokei # SLOC counter
    traceroute
    usbutils # lsusb
    watchexec
    xclip
    xxd
    youtube-dl
    zef # Package manager for Raku

    # Networking
    # TODO: Package https://github.com/dreibh/subnetcalc
    ipcalc # cidr, ipv4-only, colorful
    nmap
    sipcalc # cidr, ipv4/ipv6, non-colorful
    tcpdump
    whois
    # (lowPrio graalvm11-ce) # Don't override node/ruby.
  ];

  programs.man = {
    enable = true;
    generateCaches = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "scott";
  home.homeDirectory = "/home/scott";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
