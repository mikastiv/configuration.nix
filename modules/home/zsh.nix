{ username, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";
    shellAliases = {
      ls = "eza";
      cat = "bat";
      gl = "git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n'";
      nix-rebuild = "sudo nixos-rebuild switch --flake /home/${username}/.flake#nixos";
      nix-delete-old-boot = "sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system";
    };
    initContent = ''
      fpath=(/home/${username}/.zig-completions $fpath)
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
}
