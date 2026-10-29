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
    herdr.url = "github:herdrdev/herdr/v0.9.3";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      herdr,
      ...
    }:
    let
      mkDarwin =
        {
          username,
          extraHomebrewCasks ? [ ],
          extraNixPackages ? (_: [ ]),
        }:
        nix-darwin.lib.darwinSystem {
          modules = [
            { nixpkgs.overlays = [ (import ./overlays/ollama-mlx.nix) ]; }
            ./nix-darwin/configuration.nix
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            ./nix-darwin/home-manager.nix
            ./nix-darwin/homebrew.nix
          ];
          specialArgs = {
            inherit
              username
              extraHomebrewCasks
              extraNixPackages
              herdr
              ;
          };
        };
    in
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;

      darwinConfigurations = {
        "oyopen-mbp" = mkDarwin {
          username = "hikaru";
          extraHomebrewCasks = [
            "kicad"
          ];
          extraNixPackages = pkgs: with pkgs; [ ollama ];
        };
        "work-mbp" = mkDarwin {
          username = "iwasa";
          extraHomebrewCasks = [ ];
          extraNixPackages = pkgs: with pkgs; [ ];
        };
      };
    };
}
