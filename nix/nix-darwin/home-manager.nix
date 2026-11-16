{
  extraNixPackages,
  username,
  herdr,
  ...
}:
{
  users.users.${username}.home = "/Users/${username}";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit username extraNixPackages herdr;
  };
  home-manager.users.${username} = ../home-management/home.nix;
}
