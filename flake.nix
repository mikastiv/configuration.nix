{
  description = "mikastiv's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, lanzaboote, ... } @inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "mikastiv";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
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
        ./modules/ghidra.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = ./home.nix;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit username;
            inherit unstablePkgs;
          };
        }

        lanzaboote.nixosModules.lanzaboote
        ({ pkgs, lib, ... }: {
          environment.systemPackages = [
            pkgs.sbctl
          ];

          boot.loader.systemd-boot.enable = lib.mkForce false;
          boot.lanzaboote.enable = true;
          boot.lanzaboote.pkiBundle = "/var/lib/sbctl";
        })
      ];
    };
  };
}
        
