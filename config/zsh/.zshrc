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

# Nix
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/hikaru/.lmstudio/bin"
# End of LM Studio CLI section

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/hikaru/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
