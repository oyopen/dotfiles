# aliases
alias ll="ls -al"
alias vi="nvim"
alias vim="nvim"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
# sheldon
eval "$(sheldon source)"

# Starship
eval "$(starship init zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
