{ config, pkgs, username, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    _1password-gui
    brave
    discord
    cpufetch
    ncdu
  ];

  home.file = {
    ".config/ghostty/config".source = dotfiles/ghostty/config;
    ".config/ncdu/config".source = dotfiles/ncdu/config;
    ".config/lazygit/config.yml".source = dotfiles/lazygit/lazygit.yml;
    ".config/starship.toml".source = dotfiles/starship/starship.toml;
  };

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

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      defaultKeymap = "emacs";
      shellAliases = {
        ls = "eza";
        l = "eza -lab";
        cat = "bat";
        gs = "git status";
        gl = "git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n'";
        gd = "git diff";
      };
    };
  };

  imports = [
    ./modules/git.nix
    ./modules/helix.nix
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
