{
  description = "Home Manager configuration of hikaru";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      ...
    }:
    let
      mkDarwin =
        username:
        nix-darwin.lib.darwinSystem {
          modules = [
            ./nix-darwin/configuration.nix
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            ./nix-darwin/home-manager.nix
            ./nix-darwin/homebrew.nix
          ];
          specialArgs = {
            inherit username;
          };
        };
    in
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;

      darwinConfigurations = {
        "oyopen-mbp" = mkDarwin "hikaru";
        "work-mbp" = mkDarwin "iwasa";
      };
    };
}
