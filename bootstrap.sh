#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/thomas-young1/dotfiles.git}"

if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
    printf 'This bootstrap currently supports Apple Silicon Macs only.\n' >&2
    exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
    printf 'Administrator access is required to install Homebrew.\n'
    sudo -v
    printf 'Installing Homebrew...\n'
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v mise >/dev/null 2>&1; then
    printf 'Installing mise...\n'
    brew install mise
fi

if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    if [[ -e "$DOTFILES_DIR" ]]; then
        printf '%s exists but is not a Git repository. Move it aside and rerun.\n' "$DOTFILES_DIR" >&2
        exit 1
    fi

    printf 'Cloning dotfiles into %s...\n' "$DOTFILES_DIR"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

export MISE_GLOBAL_CONFIG_FILE="$DOTFILES_DIR/mise/config.toml"

printf 'Applying machine configuration...\n'
mise bootstrap --yes

printf '\nBootstrap complete.\n'
