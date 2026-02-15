{
  description = "mikastiv's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig-completions = {
      url = "git+https://codeberg.org/ziglang/shell-completions";
      flake = false;
    };

    ziginit = {
      url = "git+https://codeberg.org/mikastiv/ziginit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      lanzaboote,
      helix,
      zig-completions,
      ziginit,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "mikastiv";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ ];
      };

      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;

        specialArgs = {
          inherit inputs;
          inherit host;
          inherit username;
          inherit unstablePkgs;
        };

        modules = [
          ./configuration.nix

          ./modules/plasma.nix
          ./modules/1password.nix
          ./modules/steam.nix
          ./modules/chromium_policies.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = ./home.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit username;
              inherit unstablePkgs;
              inherit helix;
              inherit zig-completions;
              inherit ziginit;
            };
          }

          lanzaboote.nixosModules.lanzaboote
          (
            { pkgs, lib, ... }:
            {
              environment.systemPackages = [
                pkgs.sbctl
              ];

              boot.loader.systemd-boot.enable = lib.mkForce false;
              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
                autoGenerateKeys.enable = true;
                autoEnrollKeys.enable = true;
              };
            }
          )
        ];
      };
    };
}
