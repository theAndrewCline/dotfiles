{
  description = "Andrew Cline's Nix configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    unstable-nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, unstable-nixpkgs, ... }:

    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstable = unstable-nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        sleepydesktop = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
        };
      };

      homeConfigurations = {
        acline = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = let
            defaults = { pkgs, ... }: {
              _module.args.pkgs-unstable = import unstable-nixpkgs {
                inherit (pkgs.stdenv.targetPlatform) system;
              };
            };
          in [ defaults ./home.nix ];
        };
      };
    };
}
