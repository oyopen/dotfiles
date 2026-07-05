#!/bin/bash
set -euo pipefail

BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

targets=(
    ~/.config/karabiner
    ~/.config/mise
    ~/.config/nvim
    ~/.config/sheldon
    ~/.zshrc
    ~/.zprofile
)

has_backup=false
for target in "${targets[@]}"; do
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        if [ "$has_backup" = false ]; then
            mkdir -p "$BACKUP_DIR"
            has_backup=true
        fi
        mv "$target" "$BACKUP_DIR/"
        echo "  $target -> $BACKUP_DIR/$(basename "$target")"
    fi
done

if [ "$has_backup" = true ]; then
    echo "Backups saved to: $BACKUP_DIR"
else
    echo "No files to backup"
fi
