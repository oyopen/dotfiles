# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Nix
. "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"

export PATH="$PATH:$HOME/.lmstudio/bin"
export PATH="$HOME/.rd/bin:$PATH"
