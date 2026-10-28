#!/bin/sh

# Login shell entry point: sets PATH for all shells, then hands off to .bashrc
# under bash. zsh sources this file from .zshrc. Env vars live in .exports.sh.

prepend_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) [ -d "$1" ] && PATH="$1:$PATH" ;;
  esac
}

prepend_path "/usr/local/bin"
prepend_path "/opt/homebrew/bin"
prepend_path "$HOME/.local/bin"
prepend_path "$HOME/bin"
unset -f prepend_path

export PATH

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

# Provisioning can't reach GitHub; finish setup on the first interactive login with a forwarded agent.
case $- in *i*)
  if [ -n "${SSH_AUTH_SOCK:-}" ] && [ -z "${CODESPACES:-}" ] && [ "$(uname)" = Linux ] &&
    { [ ! -e "$HOME/.copilot/skills" ] || ! grep -qs 'git@github.com:' "$HOME/.gitconfig.local"; }; then
    dotfiles_dir=$(dirname "$(readlink "$HOME/.profile")")
    [ -x "$dotfiles_dir/install.sh" ] && "$dotfiles_dir/install.sh" --login >/dev/null
    unset dotfiles_dir
  fi
;; esac

[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
