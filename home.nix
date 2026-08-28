{
  pkgs,
  unstablePkgs,
  lib,
  username,
  helix,
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
    unstablePkgs.kicad
    unstablePkgs.osu-lazer-bin
    unstablePkgs.renderdoc
    amdgpu_top
    dolphin-emu
    ghidra
    heroic
    krita
    mupen64plus
    musescore-evolution
    nil
    nixfmt
    ncdu
    poppler
    poop
    psmisc
    qmk
    slides
    tinyxxd
    tokei
    transcribe
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
    # ".config/helix/themes/ocean-space.toml".source = dotfiles/helix/themes/ocean-space.toml;
    ".config/yazi/yazi.toml".source = dotfiles/yazi/yazi.toml;
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
      setSessionVariables = true;
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
      enableZshIntegration = true;
    };

    helix = {
      enable = true;
      defaultEditor = true;
      package = helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "yy";
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
            sha256 = "sha256:14c32zm8nzi4i58v6r9p04khqj98i08wrnnm13831cdb7j442vva";
            version = "1.73.0";
          })
          (createChromiumExtension {
            # 1password
            id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
            sha256 = "sha256:1xh00riw12rfhfd2xhcvh0x5lp81w8r9c3av9yd59l430qi1xmiv";
            version = "8.12.32.33";
          })
          (createChromiumExtension {
            # dark reader
            id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            sha256 = "sha256:04xa6wg6fwgswi2n96js2fxfvwrdk1gzd3q2vhnqjhxdvkb1pjwx";
            version = "4.9.129";
          })
          (createChromiumExtension {
            # decentraleyes
            id = "ldpochfccmkkmhdbclfhpagapcfdljkj";
            sha256 = "sha256:056slds04sb38gcwgbrigvk05xj7mg82a9mzai7024j5lgsvwnrd";
            version = "3.0.2";
          })
          (createChromiumExtension {
            # privacy badger
            id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";
            sha256 = "sha256:09yz5w8jmn04fqzgag1d770nn8n7sg2a1vwdkdgl4x8il6kmpvxk";
            version = "2026.8.7";
          })
          (createChromiumExtension {
            # enhancer for youtube
            id = "ponfpcnoihfmfllpaingbgckeeldkhle";
            sha256 = "sha256:1r1dahy02dhsnj19dcljp4m69c7h40p3gyq97yp9j5xz5a43gz6j";
            version = "3.0.19";
          })
          (createChromiumExtension {
            # nordvpn
            id = "fjoaledfpmneenckfbpdfhkmimnjocfa";
            sha256 = "sha256:01r7wkrpqy378hb39n2xdpim15d47f32w6c9w7z6ilp2rjylmwah";
            version = "5.6.5";
          })
          (createChromiumExtension {
            # 7TV
            id = "ammjkodgmmoknidbanneddgankgfejfh";
            sha256 = "sha256:1cjchkny0g0bbczxv92gp941gsjvizm9wj223bhj8mvp4j1lhlc1";
            version = "3.1.25";
          })
        ];
    };

    git = {
      enable = true;
      lfs.enable = true;
      signing = {
        format = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcstB52WoNWkQvMLo1zGapsZRJIsTZrEqcg8265KsO/";
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
        branch.sort = "-committerdate";
        tag.sort = "-taggerdate";
        blame.date = "relative";
        log = {
          abbrevCommit = true;
          graphColors = "blue,yellow,cyan,magenta,green,red";
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
        "url \"git@github.com:\"".insteadOf = "gh:";
        "url \"git@codeberg.org:\"".insteadOf = "cb:";
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
