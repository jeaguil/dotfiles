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

[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
