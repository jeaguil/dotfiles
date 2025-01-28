#!/bin/bash

git config --global user.name "Jesus Aguilera"
git config --global user.email "jeaguil@github.com"

git config --global core.editor vim

git config --global pager.branch false

git config --global push.default current

git config --global alias.l '!. ~/.dotfiles/.githelpers && pretty_git_log'
git config --global alias.la '!git l --all'

# git pull-remote <branch-name>
# Checks out a remote branch (if it exists) and creates a local branch tracking the remote branch
git config --global alias.pull-remote '!f() { \
  if git rev-parse --quiet --verify "$1"; then \
    echo "Local branch $1 already exists."; \
  else \
    git fetch origin "$1" && git checkout -b "$1" --track origin/"$1"; \
  fi; \
}; f'

# git switch-prefix <prefix>
# Finds and switches to a local branch that matches the specified prefix
git config --global alias.switch-prefix '!f() { \
  branch=$(git branch --list "$1*" | head -n 1 | sed "s/^[* ]*//"); \
  if [ -z "$branch" ]; then \
    echo "No branch found matching prefix $1"; \
  else \
    git switch "$branch"; \
  fi; \
}; f'

ln -s ~/.dotfiles/.bashrc ~/
