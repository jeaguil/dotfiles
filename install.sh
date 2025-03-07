#!/bin/bash

# Get the absolute path of the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED="\033[31m"
NC='\033[0m'

print_header() {
  echo -e "\n${YELLOW}==== $1 ====${NC}"
}

setup_dotfiles_dir() {
  print_header "Setting up dotfiles directory"
  
  # Create symbolic link from the actual repository location to ~/.dotfiles
  if [ ! -L "$HOME/.dotfiles" ]; then
    ln -sf "$DOTFILES_DIR" "$HOME/.dotfiles"
    echo -e "${GREEN}✓${NC} Created symlink from $DOTFILES_DIR to ~/.dotfiles"
  else
    echo -e "${GREEN}✓${NC} ~/.dotfiles symlink already exists"
  fi
}

setup_symlinks() {
  print_header "Creating symlinks"

  ln -sf "$DOTFILES_DIR/.githelpers" "$HOME/.githelpers"
  ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
  echo -e "${GREEN}✓${NC} Created symlink for .gitconfig"

  if [[ "$(uname)" == "Darwin" ]]; then
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.zshrc-utils" "$HOME/.zshrc-utils"
    echo -e "${GREEN}✓${NC} Created symlink for .zshrc"
  elif [[ "$(uname)" == "Linux" ]]; then
    ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    echo -e "${GREEN}✓${NC} Created symlink for .bashrc"
  fi

  ln -sf "$DOTFILES_DIR/.profile" "$HOME/.profile"
  echo -e "${GREEN}✓${NC} Created symlink for .profile"
}

install_additional_tools() {
  print_header "Installing additional tools"
  
  if [[ "$(uname)" == "Darwin" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      echo -e "${GREEN}✓${NC} Homebrew installed"
    else
      echo -e "${GREEN}✓${NC} Homebrew already installed"
    fi
    
    brew_packages=(
      git
      wget
      vim
    )
    
    echo "Installing packages with Homebrew..."
    for package in "${brew_packages[@]}"; do
      if ! brew list "$package" &>/dev/null; then
        brew install "$package"
        echo -e "${GREEN}✓${NC} Installed $package"
      else
        echo -e "${GREEN}✓${NC} $package already installed"
      fi
    done
    
  elif [[ "$(uname)" == "Linux" ]]; then
    sudo apt-get update
    
    apt_packages=(
      git
      wget
      vim
    )
    
    echo "Installing packages..."
    for package in "${apt_packages[@]}"; do
      if ! dpkg -s "$package" &>/dev/null; then
        sudo apt-get install -y "$package"
        echo -e "${GREEN}✓${NC} Installed $package"
      else
        echo -e "${GREEN}✓${NC} $package already installed"
      fi
    done
  fi
}

print_header "Starting dotfiles installation"
cd ~ || exit

mkdir -p ~/.config

setup_dotfiles_dir

setup_symlinks

if [[ "$(uname)" == "Darwin" ]]; then
  # shellcheck disable=SC1091
  source "$DOTFILES_DIR/.zshrc-utils"
  install_oh_my_zsh
  install_zsh_plugins
fi

install_additional_tools

if [ -f "$HOME/.gitconfig" ]; then
  echo -e "${GREEN}✓${NC} Verified .gitconfig is installed at $HOME/.gitconfig"
  ls -la "$HOME/.gitconfig"
else
  echo -e "${RED}✗${NC} Failed to create .gitconfig at $HOME/.gitconfig"
fi
  
print_header "Installation complete!"
