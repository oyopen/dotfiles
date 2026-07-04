{ username, ... }:
{
  users.users.${username}.home = "/Users/${username}";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit username; };
  home-manager.users.${username} = ../home-management/home.nix;
}
