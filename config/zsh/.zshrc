# aliases
alias ll="ls -al"
alias vi="nvim"
alias vim="nvim"

# sheldon
eval "$(sheldon source)"

# zeno (keep Space/Enter handled by zsh-abbr)
if [[ -n $ZENO_LOADED ]]; then
  bindkey '^i' zeno-completion
  bindkey '^r' zeno-history-selection
  bindkey '^x^f' zeno-ghq-cd
  bindkey '^xx' zeno-insert-snippet
fi

# Starship
eval "$(starship init zsh)"

# mise (official release binary, updated with task update-mise)
if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

# direnv
eval "$(direnv hook zsh)"

