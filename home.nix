{
  pkgs,
  unstablePkgs,
  lib,
  username,
  helix,
  zig-completions,
  ziginit,
  ...
}:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    unstablePkgs.ftb-app
    unstablePkgs.godot
    unstablePkgs.ida-free
    discord
    ghidra
    heroic
    mupen64plus
    nil
    nixfmt
    ncdu
    poop
    qmk
    renderdoc
    scc
    unzip
    vlc
    wl-clipboard
    yt-dlp
    ziginit.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file = {
    ".config/ncdu/config".source = dotfiles/ncdu/config;
    ".config/lazygit/config.yml".source = dotfiles/lazygit/config.yml;
    ".config/helix/config.toml".source = dotfiles/helix/config.toml;
    # ".config/helix/themes/ocean-space.toml".source = dotfiles/helix/themes/ocean-space.toml;
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
    lazygit.enable = true;
    btop.enable = true;
    bat.enable = true;
    ripgrep.enable = true;
    fastfetch.enable = true;
    starship.enable = true;

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
      package = unstablePkgs.ghostty;
    };

    helix = {
      enable = true;
      defaultEditor = true;
      package = helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
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

    chromium = rec {
      enable = true;
      package = pkgs.ungoogled-chromium;
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
          createChromiumExtension = createChromiumExtensionFor (
            lib.versions.major package.version
          );
        in
        [
          (createChromiumExtension {
            # ublock origin
            id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
            sha256 = "sha256:0ksbby7sim15b6ym8m3yjw3zz0942r9sg43grqpv1cckb55c4ha8";
            version = "1.69.0";
          })
          (createChromiumExtension {
            # 1password
            id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
            sha256 = "sha256:0xza50c07c7k8v5h2sgyb2x2q2fkyqnwixg1999dd8qaaixp6fxw";
            version = "8.12.1.3";
          })
          (createChromiumExtension {
            # dark reader
            id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            sha256 = "sha256:1hanyryhp6a78371f5wz281h6p0bmrb5vkrfr21vjhx4sy78wrch";
            version = "4.9.120";
          })
          (createChromiumExtension {
            # decentraleyes
            id = "ldpochfccmkkmhdbclfhpagapcfdljkj";
            sha256 = "sha256:198k1hyzf3a1yz4chnx095rwqa15hkcck4ir6xs6ps29qgqw8ili";
            version = "3.0.0";
          })
          (createChromiumExtension {
            # privacy badger
            id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";
            sha256 = "sha256:0sw9f6xvck6f3jdx733nrrnrqpzcn7b4h9wmdd4an76dilhfw9n7";
            version = "2025.12.9";
          })
          (createChromiumExtension {
            # enhancer for youtube
            id = "ponfpcnoihfmfllpaingbgckeeldkhle";
            sha256 = "sha256:0j0nhyhzwhrmbc3mw67vykh5ccwgg70w3xxv1pwzl414xvr371mg";
            version = "3.0.16";
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
