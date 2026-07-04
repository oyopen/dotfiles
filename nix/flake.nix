{
  description = "Home Manager configuration of hikaru";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      mkHome =
        username:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-management/home.nix ];
          extraSpecialArgs = { inherit username; };
        };
    in
    {
      homeConfigurations = {
        # Private
        "hikaru" = mkHome "hikaru";
        # Work
        "iwasa" = mkHome "iwasa";
      };
    };
}
