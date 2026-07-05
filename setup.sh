#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> dotfiles bootstrap"

# 1. Nix インストール
"${DOTFILES_DIR}/scripts/install-nix.sh"
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh 2>/dev/null || true

# 2. 既存の設定ファイルをバックアップ
"${DOTFILES_DIR}/scripts/backup.sh"

# 3. nix-darwin で構築
HOSTNAME=$(scutil --get LocalHostName 2>/dev/null || hostname -s)
case "$HOSTNAME" in
    *oyopen*|*hikaru*) FLAKE_HOST="oyopen-mbp" ;;
    *)                 FLAKE_HOST="work-mbp" ;;
esac
echo "==> Running nix-darwin rebuild (${FLAKE_HOST})..."
nix run nix-darwin -- switch --flake "${DOTFILES_DIR}/nix#${FLAKE_HOST}"

echo ""
echo "==> Done! Restart your shell to apply all changes."
