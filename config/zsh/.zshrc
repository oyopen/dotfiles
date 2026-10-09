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
eval "$(mise activate zsh)"
