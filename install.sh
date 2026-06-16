#!/usr/bin/env sh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

have() { command -v "$1" >/dev/null 2>&1; }

setup_symlinks() {
  ln -sf "$DOTFILES_DIR/.githelpers" "$HOME/.githelpers"
  ln -sf "$DOTFILES_DIR/.gitconfig"  "$HOME/.gitconfig"
  ln -sf "$DOTFILES_DIR/.profile"    "$HOME/.profile"
  ln -sf "$DOTFILES_DIR/.zshrc"      "$HOME/.zshrc"
  ln -sf "$DOTFILES_DIR/.bashrc"     "$HOME/.bashrc"
  ln -sf "$DOTFILES_DIR/exports.sh"   "$HOME/.exports.sh"
  ln -sf "$DOTFILES_DIR/aliases.sh"   "$HOME/.aliases.sh"
}

install_omz() {
  if ! have zsh; then return; fi
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  fi
}

install_git_prompt() {
  if [ ! -f "$HOME/.git-prompt.sh" ]; then
    curl -fsSL -o "$HOME/.git-prompt.sh" \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
  fi
  if [ ! -f "$HOME/.git-completion.bash" ]; then
    curl -fsSL -o "$HOME/.git-completion.bash" \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  fi
  if [ ! -f "$HOME/.git-completion.zsh" ]; then
    curl -fsSL -o "$HOME/.git-completion.zsh" \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
  fi
}

install_copilot() {
  if ! have copilot; then
    curl -fsSL https://gh.io/copilot-install | sudo bash
  fi
}

setup_symlinks
install_omz
install_git_prompt
install_copilot
