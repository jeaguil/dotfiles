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
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.gz) tar xzf "$1" ;;
      *.tar)    tar xf  "$1" ;;
      *.zip)    unzip   "$1" ;;
      *.7z)     7z x    "$1" ;;
      *)        echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
