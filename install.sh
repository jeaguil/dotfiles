#!/usr/bin/env sh

DOTFILES_DIR=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
  printf "\n%b==== %s ====%b\n" "${YELLOW}" "$1" "${NC}"
}

setup_symlinks() {
  print_header "Creating symlinks"

  ln -sf "$DOTFILES_DIR/.githelpers" "$HOME/.githelpers"
  ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
  printf "%b✓%b Created symlink for .gitconfig\n" "${GREEN}" "${NC}"

  ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  printf "%b✓%b Created symlink for .zshrc\n" "${GREEN}" "${NC}"

  ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
  printf "%b✓%b Created symlink for .bashrc\n" "${GREEN}" "${NC}"

  ln -sf "$DOTFILES_DIR/.profile" "$HOME/.profile"
  printf "%b✓%b Created symlink for .profile\n" "${GREEN}" "${NC}"
}

verify_symlink() {
  symlink="$1"
  target="$2"

  if [ -L "$symlink" ]; then
    actual_target=$(readlink "$symlink")
    if [ "$actual_target" = "$target" ]; then
      printf "%b✓%b Verified %s -> %s\n" "${GREEN}" "${NC}" "$symlink" "$target"
    else
      printf "%b✗%b Invalid symlink: %s -> %s (expected %s)\n" "${RED}" "${NC}" "$symlink" "$actual_target" "$target"
    fi
  else
    if [ -e "$symlink" ]; then
      printf "%b✗%b %s exists but is not a symlink\n" "${RED}" "${NC}" "$symlink"
    else
      printf "%b✗%b %s does not exist\n" "${RED}" "${NC}" "$symlink"
    fi
  fi
}

install_tools() {
  print_header "Installing tools"

  if command -v copilot >/dev/null 2>&1; then
    printf "%b✓%b GitHub Copilot CLI already installed\n" "${GREEN}" "${NC}"
  else
    printf "Installing GitHub Copilot CLI...\n"
    if curl -fsSL https://gh.io/copilot-install | sudo bash; then
      printf "%b✓%b GitHub Copilot CLI installed successfully\n" "${GREEN}" "${NC}"
    else
      printf "%b✗%b Failed to install GitHub Copilot CLI\n" "${RED}" "${NC}"
    fi
  fi
}

print_header "Starting dotfiles installation"

setup_symlinks

install_tools

print_header "Verifying installation"

verify_symlink "$HOME/.githelpers" "$DOTFILES_DIR/.githelpers"
verify_symlink "$HOME/.gitconfig" "$DOTFILES_DIR/.gitconfig"
verify_symlink "$HOME/.zshrc" "$DOTFILES_DIR/.zshrc"
verify_symlink "$HOME/.bashrc" "$DOTFILES_DIR/.bashrc"
verify_symlink "$HOME/.profile" "$DOTFILES_DIR/.profile"

print_header "Installation complete!"
