# Path to your oh-my-zsh installation (if using oh-my-zsh)
export ZSH="$HOME/.oh-my-zsh"

# Load oh-my-zsh (if installed)
if [ -d "$ZSH" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Set the prompt
PROMPT='%n@%m %1~ %# '

# Set up the history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Set up aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Enable color support for `ls` and add handy aliases
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi

# Set up environment variables
export EDITOR='vim'
export VISUAL='vim'

# Set up path (including Homebrew paths)
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin:/opt/homebrew/bin:/opt/homebrew/sbin"

# Enable command auto-correction
setopt CORRECT

# Share history between all sessions
setopt SHARE_HISTORY

# Enable case-insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Enable autocomplete suggestions as you type
if command -v zsh-autosuggestions >/dev/null 2>&1; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax highlighting (requires zsh-syntax-highlighting)
if [ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load custom scripts (if any)
if [ -d "$HOME/.zsh_custom" ]; then
  for script in $HOME/.zsh_custom/*.zsh; do
    source $script
  done
fi

# Custom function examples
mkcd () {
  mkdir -p "$1" && cd "$1"
}

extract () {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2) tar xvjf "$1" ;;
      *.tar.gz)  tar xvzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xvf "$1" ;;
      *.tbz2)    tar xvjf "$1" ;;
      *.tgz)     tar xvzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

autoload -Uz vcs_info
precmd () { vcs_info }
zstyle ':vcs_info:*' formats ' %s(%F{red}%b%f)'

PS1='%n@%m %F{red}%/%f$vcs_info_msg_0_ $ '
