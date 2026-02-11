set -gx EDITOR vim
set -gx VISUAL vim
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LESS "-R"

set -g fish_history_size 10000

if test -d $HOME/bin
    fish_add_path $HOME/bin
end
if test -d $HOME/.local/bin
    fish_add_path $HOME/.local/bin
end

if test (uname) = Darwin
    test -d /opt/homebrew/bin; and fish_add_path /opt/homebrew/bin
    test -d /usr/local/bin; and fish_add_path /usr/local/bin
end

function fish_prompt
    set_color green
    echo -n (whoami)@(hostname -s)
    set_color normal
    echo -n ":"
    set_color blue
    echo -n (prompt_pwd)
    set_color normal
    
    if git rev-parse --git-dir > /dev/null 2>&1
        set_color yellow
        echo -n " ("(git branch --show-current 2>/dev/null)")"
        set_color normal
    end
    
    echo
    echo -n "\$ "
end

alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

if test (uname) = Darwin
    alias ip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d' ' -f2"
    alias flush-dns="sudo dscacheutil -flushcache; and sudo killall -HUP mDNSResponder"
    alias top-cpu="top -o cpu"
    alias top-mem="top -o rsize"
end

if test (uname) = Linux
    alias ls='ls --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
end

function extract
    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted via extract()"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

if command -v rbenv > /dev/null 2>&1
    rbenv init - fish | source
end

if test -f $HOME/.config/fish/config.local.fish
    source $HOME/.config/fish/config.local.fish
end
