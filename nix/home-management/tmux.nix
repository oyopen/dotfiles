{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;

    extraConfig = ''
      # true color
      set -ag terminal-overrides ",xterm-256color:RGB"

      # pane index
      set -g pane-base-index 1
      set -g renumber-windows on

      # new window/pane in current path
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind - split-window -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

      # vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # pane resize
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # copy mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"

      # popup (scratch terminal)
      # 背景を端末デフォルトにして透過を効かせる
      bind p display-popup -E -s "bg=default" -S "bg=default" -w 80% -h 80% -d "#{pane_current_path}"

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # status bar positiont
      set-option -g status-position top

      # catppuccin
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_status_background "none"

      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_current_text " #W"
      set -g @catppuccin_window_flags "icon"
      set -g @catppuccin_window_current_fill "all"

      set -g status-left "#{E:@catppuccin_status_session} "
      set -g status-right-length 100
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#{E:@catppuccin_status_battery}"
      set -ag status-right "#{E:@catppuccin_status_date_time}"
      set -g @catppuccin_date_time_text " %m/%d %H:%M"
      set -g @catppuccin_directory_text " #{pane_current_path}"

      # tmux-cpu plugin uses string interpolation on status-right at load time,
      # but catppuccin v2 defers expansion via #{l:...}, so the replacement never happens.
      # Override with direct script paths so catppuccin can call them at display time.
      set -g @catppuccin_cpu_text " #(${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/scripts/cpu_percentage.sh)"
      set -g @catppuccin_battery_text " #(${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/scripts/battery_percentage.sh)"
      set -g @catppuccin_battery_icon "#(${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/scripts/battery_icon.sh) "

      # resurrect / continuum
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'
    '';

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      cpu
      battery
      {
        plugin = catppuccin;
        extraConfig = "";
      }
    ];
  };
}
