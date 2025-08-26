# Path configuration
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

[ -f "$HOME/.profile" ] && source "$HOME/.profile"

if [ -z "$ZSH_VERSION" ]; then
  echo "Warning: This script is intended to be sourced in zsh, not another shell."
  exit 1
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "Oh My Zsh installed"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="refined"

HISTSIZE=10000
HISTFILESIZE=10000
SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS  # Don't record duplicates
setopt HIST_FIND_NO_DUPS     # Don't show duplicates when searching
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS     # Don't write duplicate entries
setopt SHARE_HISTORY         # Share history between terminals

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'
export VISUAL='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

hash -d dots=~/.dotfiles

alias ip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\\  -f2"
alias flush-dns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias top-cpu="top -o cpu"
alias top-mem="top -o rsize"

extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.gz)   tar xzf $1     ;;
      *.tar)      tar xf $1      ;;
      *.zip)      unzip $1       ;;
      *.7z)       7z x $1        ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi
