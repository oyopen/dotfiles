{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    extraConfig = ''
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
    ];
  };
}
