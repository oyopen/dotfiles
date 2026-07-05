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
      "arc"
      "font-code-new-roman-nerd-font"
      "ghostty"
      "karabiner-elements"
      "postman"
      "rancher"
      "raycast"
      "redis-insight"
      "slack"
      "slack-cli"
      "soundsource"
      "zed"
      "1password"
    ];
  };
}
