#!/bin/bash
set -euo pipefail

MISE_BIN="${HOME}/.local/bin/mise"

# PATH 上に Nix 版が残っていても、公式バイナリの導入をスキップしない。
if [[ -x "$MISE_BIN" ]]; then
    echo "mise is already installed at ${MISE_BIN}"
    "$MISE_BIN" --version
    exit 0
fi

INSTALLER=$(mktemp)
trap 'rm -f "$INSTALLER"' EXIT

echo "Installing the official mise binary..."
curl -fsSL https://mise.run -o "$INSTALLER"
MISE_INSTALL_PATH="$MISE_BIN" MISE_INSTALL_HELP=0 sh "$INSTALLER"
"$MISE_BIN" --version
