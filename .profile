#!/bin/sh

[ -d "$HOME/bin" ]         && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ]  && PATH="$HOME/.local/bin:$PATH"
[ -d "/opt/homebrew/bin" ] && PATH="/opt/homebrew/bin:$PATH"
[ -d "/usr/local/bin" ]    && PATH="/usr/local/bin:$PATH"

export PATH

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
