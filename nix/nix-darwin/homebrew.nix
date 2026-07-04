{
  username,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    user = username;
    enableRosetta = false;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    casks = [
      "ghostty"
      "raycast"
      "postman"
      "redis-insight"
      "slack-cli"
      "arc"
    ];
  };
}
