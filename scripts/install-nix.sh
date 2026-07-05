#!/bin/bash
set -euo pipefail

if command -v nix &>/dev/null; then
    echo "Nix is already installed"
    exit 0
fi

echo "Installing Nix..."
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
