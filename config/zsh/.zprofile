# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Nix
. "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"

export PATH="$PATH:/Users/hikaru/.lmstudio/bin"
export PATH="/Users/hikaru/.rd/bin:$PATH"
