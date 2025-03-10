#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED="\033[31m"
NC='\033[0m'

if [[ "$(uname)" == "Darwin" ]]; then
  echo -e "${RED}✗${NC} This script is not supported on Darwin."
  exit 1
fi

echo -e "\n${YELLOW}==== Installing Additional Tools ====${NC}"

echo "Checking if package manager is available..."
# Check if another apt process is running
if pgrep -f apt > /dev/null || pgrep -f dpkg > /dev/null; then
  echo -e "${RED}✗${NC} Package manager is currently busy."
  echo "Please try again later or check running processes with:"
  echo "ps aux | grep -E 'apt|dpkg'"
  exit 1
fi

echo "Updating package lists..."
if ! sudo apt-get update; then
  echo -e "${RED}✗${NC} Failed to update package lists. Continuing anyway..."
fi

apt_packages=(
  git
  wget
  vim
)

echo "Installing packages..."
for package in "${apt_packages[@]}"; do
  if ! dpkg -s "$package" &>/dev/null; then
    echo "Installing $package..."
    if ! sudo apt-get install -y "$package"; then
      echo -e "${RED}✗${NC} Failed to install $package"
    else
      echo -e "${GREEN}✓${NC} Installed $package"
    fi
  else
    echo -e "${GREEN}✓${NC} $package already installed"
  fi
done

echo -e "\n${GREEN}✓${NC} Additional tools installation complete!"