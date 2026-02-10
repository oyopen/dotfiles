# aliases
alias ll="ls -al"
alias vi="nvim"
alias vim="nvim"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Starship
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
