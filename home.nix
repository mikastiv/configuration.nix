{
  pkgs,
  unstablePkgs,
  lib,
  username,
  helix,
  ghostty,
  zig-completions,
  ziginit,
  crx-updater,
  ...
}:

let
  chromiumPkg = pkgs.ungoogled-chromium;
in
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    unstablePkgs.ftb-app
    unstablePkgs.godot
    unstablePkgs.ida-free
    unstablePkgs.renderdoc
    ghidra
    heroic
    kicad
    mupen64plus
    nil
    nixfmt
    ncdu
    poppler
    poop
    psmisc
    qmk
    scc
    slides
    vlc
    wl-clipboard
    yt-dlp
    _7zz

    crx-updater.packages.${pkgs.stdenv.hostPlatform.system}.default
    ziginit.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file = {
    ".config/ncdu/config".source = dotfiles/ncdu/config;
    ".config/lazygit/config.yml".source = dotfiles/lazygit/config.yml;
    ".config/helix/config.toml".source = dotfiles/helix/config.toml;
    ".config/helix/themes/ocean-space.toml".source = dotfiles/helix/themes/ocean-space.toml;
    ".config/ghostty/config".source = dotfiles/ghostty/config;
    ".config/starship.toml".source = dotfiles/starship/starship.toml;
    ".config/autostart/OpenRGB.desktop".source = dotfiles/OpenRGB/OpenRGB.desktop;
    ".config/OpenRGB/mikastiv.orp".source = dotfiles/OpenRGB/mikastiv.orp;
    ".ssh/config".source = dotfiles/ssh/config;
    ".zig-completions" = {
      source = zig-completions;
      recursive = true;
    };
  };

  home.sessionPath = [ ];
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      templates = null;
      publicShare = null;
    };
  };

  programs = {
    bat.enable = true;
    btop.enable = true;
    discord.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    jq.enable = true;
    lazygit.enable = true;
    ripgrep.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      icons = "auto";
      git = true;
    };

    ghostty = {
      enable = true;
      installBatSyntax = true;
      package = ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    helix = {
      enable = true;
      defaultEditor = true;
      package = helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    thunderbird = {
      enable = true;
      profiles.${username} = {
        isDefault = true;
      };
      settings = {
        "general.useragent.override" = "";
        "privacy.donottrackheader.enabled" = true;
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      defaultKeymap = "emacs";
      shellAliases = {
        ls = "eza";
        cat = "bat";
        gl = "git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n'";
        nix-rebuild = "sudo nixos-rebuild switch --flake /home/${username}/.flake#nixos";
      };
      completionInit = ''
        fpath=(/home/${username}/.zig-completions $fpath)
        autoload -U compinit
        compinit
      '';
      history = {
        append = true;
        share = true;
        findNoDups = true;
        ignoreAllDups = true;
        ignoreDups = true;
        ignoreSpace = true;
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };

    chromium = {
      enable = true;
      package = chromiumPkg;
      extensions =
        let
          createChromiumExtensionFor =
            browserVersion:
            {
              id,
              sha256,
              version,
            }:
            {
              inherit id;
              inherit version;
              crxPath = builtins.fetchurl {
                url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
                name = "${id}.crx";
                inherit sha256;
              };
            };
          createChromiumExtension = createChromiumExtensionFor (lib.versions.major chromiumPkg.version);
        in
        [
          (createChromiumExtension {
            # ublock origin
            id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
            sha256 = "sha256:0sf88f9wpf300v02k40i9sda6wysvlgf4smmggf6awpwb1hyd1hl";
            version = "1.70.0";
          })
          (createChromiumExtension {
            # 1password
            id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
            sha256 = "sha256:0pii82j1zs36b63q8sa19rhgx2ak8bypmwafrbm7m1v168jw9kyg";
            version = "8.12.12.44";
          })
          (createChromiumExtension {
            # dark reader
            id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            sha256 = "sha256:05khd2bjdzfa2101gv11fmqc1lrsd115axpjx6gphw3f4n1nj24c";
            version = "4.9.125";
          })
          (createChromiumExtension {
            # decentraleyes
            id = "ldpochfccmkkmhdbclfhpagapcfdljkj";
            sha256 = "sha256:0k4rxywbr4cgp03wsz51g8x127s4g0a7hkb5g4ygzmp2n8npn9ab";
            version = "3.0.1";
          })
          (createChromiumExtension {
            # privacy badger
            id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";
            sha256 = "sha256:0xl9zqmm92g03c39aqgrpzkvk8k9r376amx2x5z3sip89sy7daa8";
            version = "2026.2.20";
          })
          (createChromiumExtension {
            # enhancer for youtube
            id = "ponfpcnoihfmfllpaingbgckeeldkhle";
            sha256 = "sha256:0sdn9ardadknc2qpbxyc3sr6y6wdpgzncmr2alwrzz7a29gml1y7";
            version = "3.0.17";
          })
          (createChromiumExtension {
            # nordvpn
            id = "fjoaledfpmneenckfbpdfhkmimnjocfa";
            sha256 = "sha256:15w901mf3d4v6mkb992k69dq5d1a61yh6q5abfd07vrvin5n3c4n";
            version = "5.5.1";
          })
        ];
    };

    git = {
      enable = true;
      lfs.enable = true;
      signing = {
        format = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTRFw7gvXr/DU24t69Tex3Xw7jtEM2RSkU60OmKr+41";
        signByDefault = true;
        signer = "/run/current-system/sw/bin/op-ssh-sign";
      };
      ignores = [
        "*.swp"
        ".direnv"
      ];
      settings = {
        user = {
          email = "mikastiv@outlook.com";
          name = "mikastiv";
        };
        init.defaultBranch = "main";
        branch.sort = "-commiterdate";
        tag.sort = "-taggerdate";
        blame.date = "relative";
        log = {
          abbrevCommit = true;
          graphColors = "blue,yellow,cyan,magenta,green,red";
        };
        "color \"decorate\"" = {
          HEAD = "red";
          branch = "blue";
          tag = "yellow";
          remoteBranch = "magenta";
        };
        "color \"branch\"" = {
          current = "magenta";
          local = "default";
          remote = "yellow";
          upstream = "green";
          plain = "blue";
        };
        pull = {
          rebase = true;
          default = "current";
        };
        push = {
          autoSetupRemote = true;
          default = "current";
          followTags = true;
        };
        rebase = {
          autoStash = true;
          missingCommitsCheck = "warn";
        };
        rerere.enable = true;
        core = {
          compression = 9;
          whitespace = "trailing-space,space-before-tab";
          preloadindex = true;
        };
        "url \"git@github.com:/\"".insteadOf = "gh:";
        status = {
          branch = true;
          showStash = true;
          showUntrackedFiles = "all";
        };
      };
    };
  };

  imports = [
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
