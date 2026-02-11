#!/usr/bin/env sh

set -x

DOTFILES_DIR=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )

have() { command -v "$1" >/dev/null 2>&1; }

setup_symlinks() {
  ln -sf "$DOTFILES_DIR/.githelpers" "$HOME/.githelpers"
  ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
  mkdir -p "$HOME/.config/fish"
  ln -sf "$DOTFILES_DIR/config.fish" "$HOME/.config/fish/config.fish"
  ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
  ln -sf "$DOTFILES_DIR/.profile" "$HOME/.profile"
}

install_tools() {
  if ! have fish ; then
    if [ "$(uname)" = "Darwin" ]; then
      have brew && brew install fish 2>/dev/null
    else
      have apt-get && sudo apt-get install -y fish 2>/dev/null
    fi
  fi

  if ! have copilot; then
    curl -fsSL https://gh.io/copilot-install | sudo bash 2>/dev/null
  fi
}

setup_symlinks

install_tools
