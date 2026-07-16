{
  username,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = username;
  nix.enable = false;
  # nix-darwin のデフォルト (nano) を上書き
  environment.variables.EDITOR = "nvim";
}
