{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mikastiv";
  home.homeDirectory = "/home/mikastiv";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    brave
    discord
    onefetch
    cpufetch
    wl-clipboard
    zigpkgs.master
    ncdu
    unzip
    zip
    scc
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/ghostty/config".source = dotfiles/ghostty/config;
    ".config/kitty/kitty.conf".source = dotfiles/kitty/kitty.conf;
    ".config/kitty/theme.conf".source = dotfiles/kitty/neowave.conf;
    ".config/ncdu/config".source = dotfiles/ncdu;
    ".config/lazygit/config.yml".source = dotfiles/lazygit.yml;
    ".config/wezterm/wezterm.lua".source = dotfiles/wezterm/wezterm.lua;
    ".config/starship.toml".source = dotfiles/starship.toml;
    ".config/nvim" = {
      source = dotfiles/nvim;
      recursive = true;
    };
  };

  home.sessionVariables = {
    #EDITOR = "nvim";
  };

  home.sessionPath = [];

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  programs = {
    lazygit.enable = true;
    htop.enable = true;
    btop.enable = true;
    bat.enable = true;
    ripgrep.enable = true;
    fastfetch.enable = true;
    starship.enable = true;

    vscode.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "ocean-space";
        editor = {
          line-number = "relative";
          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "warning";
          cursor-shape.insert = "bar";
          popup-border = "all";
          lsp.display-progress-messages = true;
          statusline = {
            right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
            mode.normal = "NORMAL";
            mode.insert = "INSERT";
            mode.select = "SELECT";
          };
        };
      };
      themes = {
        ocean-space = let
          white = "#d5ced9";
          light-gray = "#6e7178";
          cyan = "#87d3f8";
          blue = "#3a75c4";
          orange = "#f39c12";
          yellow = "#f2f27a";
          purple = "#c74ded";
          red = "#e25822";
          pink = "#ff00aa";
          hot-pink = "#f92672";
          green = "#14b37d";
          bg = "#0f111a";
          bg-light = "#191b24";
          selected = "#414a5b";
          cursor = "#b4b4b4";
          bar = "#00b491";
        in {
          "attribute" = { fg = yellow; };
          "comment" = { fg = light-gray; };
          "constant" = { fg = red; };
          "constant.numeric" = { fg = orange; };
          "constant.builtin" = { fg = purple; };
          "constant.character.escape" = { fg = red; };
          "constructor" = { fg = yellow; };
          "function" = { fg = yellow; };
          "function.builtin" = { fg = orange; };
          "function.macro" = { fg = orange; };
          "keyword" = { fg = purple; };
          "label" = { fg = white; };
          "namespace" = { fg = white; };
          "operator" = { fg = red; };
          "punctuation" = { fg = white; };
          "special" = { fg = orange; };
          "string" = { fg = green; };
          "tag" = { fg = orange; };
          "type" = { fg = orange; };
          "type.builtin" = { fg = purple; };
          "type.enum" = { fg = purple; };
          "variable" = { fg = cyan; };
          "markup.heading" = { fg = hot-pink; };
          "markup.list" = { fg = yellow; };
          "markup.link" = { fg = purple; };
          "markup.quote" = { fg = green; };
          "ui.background" = { bg = bg; };
          "ui.text" = white;
          "ui.selection" = { bg = selected; };
          "ui.linenr" = { fg = light-gray; };
          "ui.linenr.selected" = { fg = white; };
          "ui.cursor" = { bg = cursor; fg = bg; };
          "ui.cursor.match" = { bg = selected; };
          "ui.statusline" = { bg = bar; fg = bg; };
          "ui.window" = light-gray;
          "ui.menu.selected" = { bg = selected; };
          "ui.debug" = red;
          "diff.plus" = green;
          "diff.minus" = red;
          "diff.delta" = orange;
          "diagnostic.info".underline = { color = blue; style = "curl"; };
          "diagnostic.hint".underline = { color = green; style = "curl"; };
          "diagnostic.warning".underline = { color = yellow; style = "curl"; };
          "diagnostic.error".underline = { color = red; style = "curl"; };
          "diagnostic.unnecessary" = { modifiers = ["dim"]; };
          "diagnostic.deprecated" = { modifiers = ["crossed_out"]; };
          "info" = { fg = blue; };
          "hint" = { fg = green; };
          "warning" = { fg = yellow; };
          "error" = { fg = red; };
        };
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      userEmail = "mikastiv@outlook.com";
      userName = "mikastiv";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingKey = "~/.ssh/id_ed25519_sign.pub";
      };
      ignores = [
        "*.swp"
        ".direnv"
      ];
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
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
