{
  description = "Andrew Cline's Nix configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    unstable-nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      unstable-nixpkgs,
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
          modules = [ ./configuration.nix ];
        };
      };

      homeConfigurations = {
        acline = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit pkgs-unstable;
          };
        };

        cline = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [ ./macos.nix ];
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
