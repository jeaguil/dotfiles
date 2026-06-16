# Load PATH (.profile) then shared env/aliases used by both bash and zsh.
[ -f "$HOME/.profile" ] && source "$HOME/.profile"
[ -f "$HOME/.exports.sh" ] && source "$HOME/.exports.sh"
[ -f "$HOME/.aliases.sh" ] && source "$HOME/.aliases.sh"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# Prefer zsh's own (rich) git completion, which has descriptions for every
# subcommand and flag, over the minimal wrapper that Homebrew's git installs
# into site-functions. zsh's native completions live alongside _complete, so
# we locate that directory and put it first on fpath. This must run before
# oh-my-zsh, which calls compinit and locks in completion definitions.
() {
  local -a nd
  nd=(${^fpath}/_complete(N))
  (( $#nd )) && fpath=("${nd[1]:h}" $fpath)
}

source "$ZSH/oh-my-zsh.sh"

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

ZSH_SYNTAX_HIGHLIGHTING="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$ZSH_SYNTAX_HIGHLIGHTING" ] && source "$ZSH_SYNTAX_HIGHLIGHTING"

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
