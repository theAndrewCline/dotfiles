{
  description = "Andrew Cline's Nix configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    unstable-nixpkgs.url = "nixpkgs/nixos-unstable";

    stylix.url = "github:danth/stylix/release-24.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      unstable-nixpkgs,
      stylix,
      ...
    }:

    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = unstable-nixpkgs.legacyPackages.${system};
    in

    {
      nixosConfigurations = {
        sleepydesktop = lib.nixosSystem {
          inherit system;
          modules = [
            stylix.nixosModules.stylix
            ./configuration.nix
          ];
        };
      };

      homeConfigurations = {
        acline = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            stylix.homeManagerModules.stylix
          ];
          extraSpecialArgs = {
            inherit pkgs-unstable;
          };
        };

        cline = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [
            ./macos.nix
            stylix.homeManagerModules.stylix
          ];
          extraSpecialArgs =
            let
              pkgs-unstable = unstable-nixpkgs.legacyPackages."aarch64-darwin";
            in
            {
              inherit pkgs-unstable;
            };
        };
      };
    };
}
