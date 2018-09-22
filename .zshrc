# {{{ Antigen - ZSH plugin manager

# Antigen: https://github.com/zsh-users/antigen

# ADOTDIR — This directory is used to store all the repo clones, your bundles,
# themes, caches and everything else Antigen requires to run smoothly. Defaults
# to $HOME/.antigen
ADOTDIR=~/.zsh/.antigen

# Load
source ~/.zsh/antigen/antigen.zsh

# Load oh-my-zsh - many plugins/themes require its core library
ZSH=~/.zsh/.oh-my-zsh
antigen use oh-my-zsh

# Bundles to use
antigen bundles << EOBUNDLES
    aws
    bundler
    docker
    docker-compose
    git
    github
    kubectl
    pip
    postgres
    python
    rbenv
    ssh-agent
    systemctl
    tmux
    Tarrasch/zsh-autoenv
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-syntax-highlighting
EOBUNDLES

# Apply theme
#antigen theme bureau
#POWERLEVEL9K_MODE='nerdfont-complete'
DEFAULT_UER=${USER}
antigen theme bhilburn/powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=( dir vcs ip disk_usage load newline context )
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique

# Antigen config complete
antigen apply

# }}}
# {{{ Key bindings 

# {{{ for history-substring-search plugin

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
# }}}

# Enables pressing ESC-v to open current command line in vi
bindkey -M vicmd v edit-command-line

# Set VI keybindings - has to be below sourcing oh my zsh as bindkey -e is set in libs/key-bindings.zsh
bindkey -v

# zsh-autoauggestions
bindkey '^ ' autosuggest-accept

# }}}
# Solarized dir colors {{{

if [ -f /usr/bin/dircolors ]; then
    eval `dircolors ~/.dir_colors`
fi

# }}}
# {{{ virtualenvwrapper: https://pypi.org/project/virtualenvwrapper/

export WORKON_HOME=$HOME/.virtualenvs
if [ -f "/etc/bash_completion.d/virtualenvwrapper" ]; then
    source /etc/bash_completion.d/virtualenvwrapper
fi
 
# }}}
# {{{ SSH agent function

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo -n "Initializing new SSH agent... "
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# }}}
# {{{ Host specific settings
case `hostname -s` in
    'yul1')
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
        #ZSH_THEME=mikeh
        ;;
esac
# }}}
# {{{ GRC: Generic colorizer
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

	# Newer (1.11) version of grc package have these nice configs to use
	if [[ -f /etc/grc.zsh ]]; then source /etc/grc.zsh; fi
fi
# }}}
# {{{ shell git prompt
# used with bureau theme

#function git_prompt_info() {
#	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
#	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
#}

# }}}
# Umask{{{

# if you install packages with pip using sudo you should probably set the umask
# options in sudoers to 022 to revert this
umask 007

# }}}
# {{{ Environment variables

export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sbin:./
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
# Sort order dotfiles first
export LC_COLLATE="C"
export EDITOR="vim"
export PAGER="less"
#export TZ=Singapore
# used for powerlevel context
export DEFAULT_USER="sedlund"

if [[ "$TERM" = screen ]]; then
	export TERM=screen-256color
elif [[ "$TERM" = xterm ]]; then
    export TERM=xterm-256color
fi

# }}}
# {{{ Aliases

alias more="less"

alias ls='ls --color=auto --group-directories-first --classify'
alias l='ls'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'

# Ansible
alias ave='ansible-vault edit'
alias avv='ansible-vault view'
alias avc='ansible-vault encrypt'

# }}}
