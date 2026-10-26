#!/bin/bash

case $- in
  *i*) ;;
    *) return ;;
esac

# Shared config: .exports.sh (env vars) and .aliases.sh (aliases/functions)
# are sourced by both bash and zsh. PATH is set in .profile.
[ -f "$HOME/.exports.sh" ] && . "$HOME/.exports.sh"
[ -f "$HOME/.aliases.sh" ] && . "$HOME/.aliases.sh"

shopt -s histappend checkwinsize cdspell globstar
HISTSIZE=10000
HISTFILESIZE=10000
HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoredups

bind 'set completion-ignore-case on' 2>/dev/null

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f "$HOME/.git-completion.bash" ] && . "$HOME/.git-completion.bash"

if [ -f "$HOME/.git-prompt.sh" ]; then
  . "$HOME/.git-prompt.sh"
  PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)")'
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]${PS1_CMD1}\n\$ '
else
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
fi

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - --no-rehash bash)"
fi

[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"
