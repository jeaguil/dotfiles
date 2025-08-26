#!/bin/bash

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED="\033[31m"
NC='\033[0m'

print_header() {
  echo -e "\n${YELLOW}==== $1 ====${NC}"
}

setup_symlinks() {
  print_header "Creating symlinks"

  ln -sf "$DOTFILES_DIR/.githelpers" "$HOME/.githelpers"
  ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
  echo -e "${GREEN}✓${NC} Created symlink for .gitconfig"

  if [[ -n "$ZSH_VERSION" ]]; then
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    echo -e "${GREEN}✓${NC} Created symlink for .zshrc"
  elif [[ -n "$BASH_VERSION" ]]; then
    ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    echo -e "${GREEN}✓${NC} Created symlink for .bashrc"
  fi

  ln -sf "$DOTFILES_DIR/.profile" "$HOME/.profile"
  echo -e "${GREEN}✓${NC} Created symlink for .profile"
}

print_header "Starting dotfiles installation"

setup_symlinks

if [[ -n "$ZSH_VERSION" ]]; then
  print_header "Setting up Oh My Zsh"

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}✓${NC} Oh My Zsh installed"
  else
    echo -e "${GREEN}✓${NC} Oh My Zsh already installed"
  fi

  print_header "Installing ZSH plugins"

  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    echo -e "${GREEN}✓${NC} zsh-syntax-highlighting installed"
  else
    echo -e "${GREEN}✓${NC} zsh-syntax-highlighting already installed"
  fi
fi

print_header "Verifying installation"

if [ -f "$HOME/.gitconfig" ]; then
  echo -e "${GREEN}✓${NC} Verified .gitconfig is installed at $HOME/.gitconfig"
  ls -la "$HOME/.gitconfig"
else
  echo -e "${RED}✗${NC} Failed to create .gitconfig at $HOME/.gitconfig"
fi
  
print_header "Installation complete!"
