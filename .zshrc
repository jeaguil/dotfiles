[ -f "$HOME/.profile" ] && source "$HOME/.profile"
[ -f "$HOME/.exports.sh" ] && source "$HOME/.exports.sh"
[ -f "$HOME/.aliases.sh" ] && source "$HOME/.aliases.sh"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
source "$ZSH/oh-my-zsh.sh"

if [ -f "$HOME/.git-completion.zsh" ]; then
  zstyle ':completion:*:*:git:*' script "$HOME/.git-completion.bash"
  fpath=("$HOME" $fpath)
  autoload -Uz compinit && compinit
fi

if [ -f "$HOME/.git-prompt.sh" ]; then
  source "$HOME/.git-prompt.sh"
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM=auto
fi

setopt PROMPT_SUBST
precmd() { PS1_GIT=$(__git_ps1 " (%s)" 2>/dev/null) }
PROMPT='%n@%m:%~${PS1_GIT}
$ '

HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt AUTO_CD
setopt NO_BEEP

source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
