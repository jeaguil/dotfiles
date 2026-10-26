# shellcheck shell=sh

alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

if [ "$(uname)" = "Darwin" ]; then
  alias ip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\  -f2"
  alias flush-dns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
  alias top-cpu="top -o cpu"
  alias top-mem="top -o rsize"
fi

if [ -x /usr/bin/dircolors ]; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
  alias ls='ls --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.gz|*.tgz)   tar xzf "$1" ;;
      *.tar.bz2|*.tbz2) tar xjf "$1" ;;
      *.tar.xz|*.txz)   tar xJf "$1" ;;
      *.tar)            tar xf  "$1" ;;
      *.gz)             gunzip  "$1" ;;
      *.bz2)            bunzip2 "$1" ;;
      *.zip)            unzip   "$1" ;;
      *.7z)             7z x    "$1" ;;
      *)                echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

upgrade() {
  if [ "$(uname)" = "Darwin" ]; then
    brew update && brew upgrade && brew cleanup
  else
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
  fi
}
