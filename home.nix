{
  pkgs,
  config,
  unstablePkgs,
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

    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";

      policies = {
        PasswordManagerEnabled = false;
        OfferToSaveLogins = false;
      };

      profiles.default = {
        isDefault = true;

        settings = {
          # Restore tabs on startup
          "browser.startup.page" = 3;
          "browser.toolbars.bookmarks.visibility" = "always";

          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "signon.generation.enabled" = false;
          "signon.management.page.enabled" = false;
        };

        search = {
          default = "ddg";
          force = true;

          engines = {
            nix-packages = {
              name = "Nix Packages";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            bing.metaData.hidden = true;
          };
        };

        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            onepassword-password-manager
            darkreader
            decentraleyes
            privacy-badger
            enhancer-for-youtube
          ];
        };
      };
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
