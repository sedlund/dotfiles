# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="blinks"
ZSH_THEME="bureau"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# User configuration

export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sbin:./:/usr/java/bin
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(autoenv bower brew bundler cloudapp coffee django emoji-clock extract fabric git github heroku lein node npm nyan pip postgres python rbenv safe-paste )
plugins=(aws autoenv bundler docker docker-compose git github history-substring-search pip postgres python rbenv safe-paste )

#export HISTFILE=/tmp/zsh_history
export EDITOR="vim"
export PAGER="less"
#export TZ=Singapore

#export PATH=$PATH:/usr/sbin:/usr/src/google_appengine:~/bin:/usr/local/share/npm/bin:/usr/local/packer
#export PATH=$PATH:
export NODE_PATH=/usr/local/lib/node_modules

bindkey -M vicmd v edit-command-line

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

if [ -f /usr/bin/dircolors ]; then
    eval `dircolors ~/.dir_colors`
fi

# Add : to select chars in gnome-terminal
if [[ -e /usr/bin/dconf ]]; then
    dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/word-char-exceptions '@ms "-#%&+,./:=?@_~"'
fi

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
if [ -f "/etc/bash_completion.d/virtualenvwrapper" ]; then
    source /etc/bash_completion.d/virtualenvwrapper
fi

# SSH agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo -n "Initializing new SSH agent... "
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Host specific configs
case `hostname -s` in
    'yyz1')
        # http://hints.macworld.com/article.php?story=20060410092629437
        #export XAUTHORITY=/tmp/.Xauthority.$USER
        alias ls="ls -F --color"
        # Source SSH settings, if applicable
        if [ -f "${SSH_ENV}" ]; then
            . "${SSH_ENV}" > /dev/null
            #ps ${SSH_AGENT_PID} doesn't work under cywgin
            ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_agent;
        }
        else
            start_agent;
        fi
        
        # z
        . ~/bin/z.sh
        function precmd () {
            _z --add "$(pwd -P)"
        } ;;
    'flip')
        # http://hints.macworld.com/article.php?story=20060410092629437
        #export XAUTHORITY=/tmp/.Xauthority.$USER
        alias ls="ls -F --color"
        # Source SSH settings, if applicable
        if [ -f "${SSH_ENV}" ]; then
            . "${SSH_ENV}" > /dev/null
            #ps ${SSH_AGENT_PID} doesn't work under cywgin
            ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_agent;
        }
        else
            start_agent;
        fi
        
        # z
        . ~/bin/z.sh
        function precmd () {
            _z --add "$(pwd -P)"
        }
        # grep --files-without-match "git" ~/.oh-my-zsh/themes/*
        ZSH_THEME=mikeh
        ;;

esac

if [[ "$TERM" = screen ]]; then
    export TERM=screen-256color
elif [[ "$TERM" = xterm ]]; then
    export TERM=xterm-256color
fi

GRC=`which grc` 2>/dev/null
if [[ "$TERM" != dumb ]] && [[ -x ${GRC} ]]
then
    alias colourify="$GRC -es --colour=auto"
    alias configure='colourify ./configure'
    alias diff='colourify diff'
    alias make='colourify make'
    alias gcc='colourify gcc'
    alias g++='colourify g++'
    alias as='colourify as'
    alias gas='colourify gas'
    alias ld='colourify ld'
    alias ps='colourify ps'
    alias netstat='colourify netstat'
    alias ping='colourify ping'
    alias traceroute='colourify /usr/sbin/traceroute'
fi

alias ave='ansible-vault edit --vault-id ~/src/teraton/ansible/vpass'
alias avv='ansible-vault view --vault-id ~/src/teraton/ansible/vpass'
alias avc='ansible-vault encrypt --vault-id ~/src/teraton/ansible/vpass'

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

#export LC_ALL=en_US.UTF-8
#export LANG=en_US.UTF-8

set -o vi

source $ZSH/oh-my-zsh.sh
