{
  extraNixPackages,
  username,
  herdr,
  mise,
  ...
}:
{
  users.users.${username}.home = "/Users/${username}";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit username extraNixPackages herdr mise;
  };
  home-manager.users.${username} = ../home-management/home.nix;
}
