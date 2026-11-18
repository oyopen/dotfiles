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

      # new session with name prompt
      bind N command-prompt -p "new session name:" "new-session -s '%%'"

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
      # prefix + p で開閉。呼び出し元のセッションIDごとに作業状態を保持する。
      # 背景を端末デフォルトにして透過を効かせる
      bind p if-shell -F '#{m:popup-$*,#{session_name}}' {
        detach-client
      } {
        # run-shell で引数の format を展開。qh;q で # とシェル特殊文字を保護する。
        run-shell -b '${pkgs.tmux}/bin/tmux -S #{q:socket_path} display-popup -c #{q:client_name} \
          -E -e TMUX= -s bg=default -S bg=default -w 80% -h 80% -d #{qh;q:pane_current_path} \
          ${pkgs.tmux}/bin/tmux -S #{q:socket_path} new-session -A -s popup-#{q:session_id} -c #{qh;q:pane_current_path}'
      }

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # status bar positiont
      set-option -g status-position top

      # Catppuccin が生成したモジュールをプラグイン読み込み後に配置する
      set -g status-left "#{E:@catppuccin_status_session} "
      set -g status-right-length 100
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#{E:@catppuccin_status_battery}"
      set -ag status-right "#{E:@catppuccin_status_date_time}"

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
        # Catppuccin は読み込み時の設定でタブやアイコンの表示書式を生成する。
        # Home Manager はこの extraConfig を run-shell の直前に出力するため、
        # @catppuccin_* は programs.tmux.extraConfig ではなく、ここで設定する。
        # TokyoNight Night のパレットで catppuccin の @thm_* を上書きする。
        # catppuccin 側は set -ogq (既存値があれば上書きしない) なので、
        # 先に値を入れておけばテーマ色を丸ごと差し替えられる。
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_status_background "none"

          set -g @catppuccin_window_text " #W"
          set -g @catppuccin_window_current_text " #W"
          set -g @catppuccin_window_flags "icon"

          set -g @catppuccin_date_time_text " %m/%d %H:%M"
          set -g @catppuccin_directory_text " #{pane_current_path}"

          # tmux-cpu plugin uses string interpolation on status-right at load time,
          # but catppuccin v2 defers expansion via #{l:...}, so the replacement never happens.
          # Override with direct script paths so catppuccin can call them at display time.
          set -g @catppuccin_cpu_text " #(${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/scripts/cpu_percentage.sh)"
          set -g @catppuccin_battery_text " #(${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/scripts/battery_percentage.sh)"
          set -g @catppuccin_battery_icon "#(${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/scripts/battery_icon.sh) "

          set -g @thm_bg "#1a1b26"
          set -g @thm_fg "#c0caf5"

          set -g @thm_rosewater "#b4f9f8"
          set -g @thm_flamingo "#f7768e"
          set -g @thm_pink "#ff007c"
          set -g @thm_mauve "#bb9af7"
          set -g @thm_red "#f7768e"
          set -g @thm_maroon "#db4b4b"
          set -g @thm_peach "#ff9e64"
          set -g @thm_yellow "#e0af68"
          set -g @thm_green "#9ece6a"
          set -g @thm_teal "#73daca"
          set -g @thm_sky "#89ddff"
          set -g @thm_sapphire "#7dcfff"
          set -g @thm_blue "#7aa2f7"
          set -g @thm_lavender "#9d7cd8"

          set -g @thm_subtext_1 "#a9b1d6"
          set -g @thm_subtext_0 "#c0caf5"
          set -g @thm_overlay_2 "#737aa2"
          set -g @thm_overlay_1 "#565f89"
          set -g @thm_overlay_0 "#414868"
          set -g @thm_surface_2 "#414868"
          set -g @thm_surface_1 "#3b4261"
          set -g @thm_surface_0 "#292e42"
          set -g @thm_mantle "#16161e"
          set -g @thm_crust "#16161e"
        '';
      }
    ];
  };
}
