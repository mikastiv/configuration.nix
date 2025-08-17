{ config, pkgs, unstablePkgs, username, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    brave
    cpufetch
    discord
    godot
    heroic
    ida-free
    ncdu
    qmk
    thunderbird
    wl-clipboard
  ];

  home.file = {
    ".config/ncdu/config".source = dotfiles/ncdu/config;
    ".config/lazygit/config.yml".source = dotfiles/lazygit/config.yml;
    ".config/helix/config.toml".source = dotfiles/helix/config.toml;
    ".config/helix/themes/ocean-space.toml".source = dotfiles/helix/themes/ocean-space.toml;
    ".config/nvim/init.lua".source = dotfiles/nvim/init.lua;
    ".config/starship.toml".source = dotfiles/starship/starship.toml;
    ".config/autostart/OpenRGB.desktop".source = dotfiles/OpenRGB/OpenRGB.desktop;
    ".config/OpenRGB/mikastiv.orp".source = dotfiles/OpenRGB/mikastiv.orp;
  };

  home.sessionPath = [
    "/home/${username}/.anyzig"
  ];

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
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
      enableZshIntegration = true;
      installBatSyntax = true;
      installVimSyntax = true;
      settings = {
        theme = "Monokai Remastered";
        keybind = [
          "ctrl+shift+h=previous_tab"
          "ctrl+shift+l=next_tab"
        ];
      };
    };

    helix = {
      enable = true;
      defaultEditor = true;
      package = unstablePkgs.helix;
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };

  imports = [
    ./modules/home/git.nix
    ./modules/home/zsh.nix
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
