#!/usr/bin/env sh

set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

have() { command -v "$1" >/dev/null 2>&1; }

link_file() {
  # A real file in the way is pulled into the repo; review it with git diff.
  if [ -e "$2" ] && [ ! -L "$2" ]; then
    if [ -n "${CODESPACES:-}" ]; then rm -f "$2"; else mv -f "$2" "$1"; fi
  fi
  ln -sf "$1" "$2"
}

setup_symlinks() {
  link_file "$DOTFILES_DIR/.githelpers" "$HOME/.githelpers"
  link_file "$DOTFILES_DIR/.gitconfig"  "$HOME/.gitconfig"
  link_file "$DOTFILES_DIR/.profile"    "$HOME/.profile"
  link_file "$DOTFILES_DIR/.zshrc"      "$HOME/.zshrc"
  link_file "$DOTFILES_DIR/.bashrc"     "$HOME/.bashrc"
  link_file "$DOTFILES_DIR/exports.sh"  "$HOME/.exports.sh"
  link_file "$DOTFILES_DIR/aliases.sh"  "$HOME/.aliases.sh"
}

clone_skills() {
  skills_repo="${SKILLS_REPO:-$(dirname "$DOTFILES_DIR")/skills}"
  [ -d "$skills_repo" ] && return 0
  if [ -n "${CODESPACES:-}" ]; then
    [ -n "${SKILLS_TOKEN:-}" ] && have gh || return 0
    GH_TOKEN="$SKILLS_TOKEN" gh repo clone jeaguil/skills "$skills_repo" -- --quiet ||
      echo "Failed to clone jeaguil/skills; check the SKILLS_TOKEN secret" >&2
  elif have gh && gh auth status >/dev/null 2>&1; then
    gh repo clone jeaguil/skills "$skills_repo" -- --quiet ||
      echo "Failed to clone jeaguil/skills with gh" >&2
  else
    # Fail fast instead of prompting when no SSH key or forwarded agent can reach GitHub.
    GIT_SSH_COMMAND="ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new" \
      git clone --quiet git@github.com:jeaguil/skills.git "$skills_repo" 2>/dev/null || true
  fi
}

link_skills() {
  skills_repo="${SKILLS_REPO:-$(dirname "$DOTFILES_DIR")/skills}"
  if [ -d "$skills_repo" ] && { [ ! -e "$HOME/skills" ] || [ -L "$HOME/skills" ]; }; then
    ln -sfn "$skills_repo" "$HOME/skills"
  fi
  [ -d "$HOME/skills" ] || return 0
  target="$HOME/.copilot/skills"
  if [ -d "$target" ] && [ ! -L "$target" ]; then return 0; fi
  mkdir -p "$HOME/.copilot"
  ln -sfn "$HOME/skills" "$target"
}

install_omz() {
  if ! have zsh; then return; fi
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  fi
}

install_git_prompt() {
  git_tag="v$(git --version | sed -E 's/^git version ([0-9]+\.[0-9]+\.[0-9]+).*/\1/')"
  base_url="https://raw.githubusercontent.com/git/git/$git_tag/contrib/completion"
  if [ ! -f "$HOME/.git-prompt.sh" ]; then
    curl -fsSL -o "$HOME/.git-prompt.sh" "$base_url/git-prompt.sh"
  fi
  if [ ! -f "$HOME/.git-completion.bash" ]; then
    curl -fsSL -o "$HOME/.git-completion.bash" "$base_url/git-completion.bash"
  fi
}

setup_symlinks
clone_skills
link_skills
install_omz
install_git_prompt
