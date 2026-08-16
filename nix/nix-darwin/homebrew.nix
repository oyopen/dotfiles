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
      "thebrowsercompany-dia"
      "font-code-new-roman-nerd-font"
      "ghostty"
      "karabiner-elements"
      "meetingbar"
      "notion"
      "notion-calendar"
      "pgadmin4"
      "postman"
      "rancher"
      "raycast"
      "redis-insight"
      "slack"
      "slack-cli"
      "soundsource"
      "tableplus"
      "zed"
      "1password"
      "1password-cli"
    ];
  };
}
