#!/usr/bin/env sh

DOTFILES_DIR=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
  printf "\n${YELLOW}==== %s ====${NC}\n" "$1"
}

setup_symlinks() {
  print_header "Creating symlinks"

  ln -sf "$DOTFILES_DIR/.githelpers" "$HOME/.githelpers"
  ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
  # shellcheck disable=SC2059
  printf "${GREEN}✓${NC} Created symlink for .gitconfig\n"

  ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  # shellcheck disable=SC2059
  printf "${GREEN}✓${NC} Created symlink for .zshrc\n"

  ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
  # shellcheck disable=SC2059
  printf "${GREEN}✓${NC} Created symlink for .bashrc\n"

  ln -sf "$DOTFILES_DIR/.profile" "$HOME/.profile"
  # shellcheck disable=SC2059
  printf "${GREEN}✓${NC} Created symlink for .profile\n"
}

verify_symlink() {
  symlink="$1"
  target="$2"

  if [ -L "$symlink" ]; then
    actual_target=$(readlink "$symlink")
    if [ "$actual_target" = "$target" ]; then
      # shellcheck disable=SC2059
      printf "${GREEN}✓${NC} Verified $symlink -> $target\n"
    else
      # shellcheck disable=SC2059
      printf "${RED}✗${NC} Invalid symlink: $symlink -> $actual_target (expected $target)\n"
    fi
  else
    if [ -e "$symlink" ]; then
      # shellcheck disable=SC2059
      printf "${RED}✗${NC} $symlink exists but is not a symlink\n"
    else
      # shellcheck disable=SC2059
      printf "${RED}✗${NC} $symlink does not exist\n"
    fi
  fi
}

print_header "Starting dotfiles installation"

setup_symlinks

print_header "Verifying installation"

verify_symlink "$HOME/.githelpers" "$DOTFILES_DIR/.githelpers"
verify_symlink "$HOME/.gitconfig" "$DOTFILES_DIR/.gitconfig"
verify_symlink "$HOME/.zshrc" "$DOTFILES_DIR/.zshrc"
verify_symlink "$HOME/.bashrc" "$DOTFILES_DIR/.bashrc"
verify_symlink "$HOME/.profile" "$DOTFILES_DIR/.profile"

print_header "Installation complete!"
