#!/bin/bash

git config --global user.name "Jesus Aguilera"
git config --global user.email "jeaguil@github.com"

git config --global core.editor vim

git config --global pager.branch false

git config --global push.default current

git config --global alias.l '!. ~/.dotfiles/.githelpers && pretty_git_log'
git config --global alias.la '!git l --all'

git config --global alias.pull-remote '!. ~/.dotfiles/.githelpers && pull_remote'

git config --global alias.switch-prefix '!. ~/.dotfiles/.githelpers && switch_prefix'

ln -s ~/.dotfiles/.bashrc ~/
