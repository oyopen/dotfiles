{
  config,
  pkgs,
  username,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    cocoapods
    fzf
    gcc
    gh
    ghq
    git
    gitui
    go-task
    jq
    mise
    neovim
    nixfmt
    postgresql
    ripgrep
    sheldon
    sqlite
    tree
    zsh
  ];

  home.file.".config/sheldon" = {
    source = ../../config/sheldon;
    recursive = true;
  };

  home.file.".zshrc" = {
    source = ../../config/zsh/.zshrc;
  };

  home.file.".zprofile" = {
    source = ../../config/zsh/.zprofile;
  };

  home.file.".config/nvim" = {
    source = ../../config/nvim;
    recursive = true;
  };

  home.file.".config/mise" = {
    source = ../../config/mise;
    recursive = true;
  };

  imports = [
    ./tmux.nix
  ];

  programs.starship.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
