{
  pkgs,
  unstablePkgs,
  username,
  helix,
  zig-completions,
  ...
}:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    unstablePkgs.ftb-app
    unstablePkgs.godot
    unstablePkgs.ida-free
    unstablePkgs.renderdoc
    discord
    ghidra
    heroic
    nil
    nixfmt
    mupen64plus
    ncdu
    poop
    qmk
    scc
    vlc
    wl-clipboard
    yt-dlp
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

    chromium = {
      enable = true;
      extensions = [
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin lite
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
        { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; } # decentraleyes
        { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # privacy badger
      ];
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

    diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
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
