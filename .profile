#!/bin/bash
# ~/.profile: executed by login shells and sourced by .zshrc
# Common environment variables and PATH modifications go here

[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
if command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
  export VISUAL="vim"
elif command -v nano >/dev/null 2>&1; then
  export EDITOR="nano"
  export VISUAL="nano"
fi

if [ -n "$ZSH_VERSION" ]; then
  [ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"
  [ -d "/usr/local/bin" ] && export PATH="/usr/local/bin:$PATH"
fi

export LESS="-R"

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local"

export PATH