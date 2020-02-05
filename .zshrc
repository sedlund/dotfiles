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
#
# https://github.com/bhilburn/powerlevel9k
POWERLEVEL9K_MODE='fontawesome-fontconfig'
#POWERLEVEL9K_MODE='nerdfont-fontconfig'
#POWERLEVEL9K_MODE='compatible'

if [[ "$TERM" = screen ]]; then
    export TERM=screen-256color
elif [[ "$TERM" = xterm || "$TERM" = linux ]]; then
    export TERM=xterm-256color
fi

#antigen theme bureau
antigen theme bhilburn/powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=( dir dir_writable vcs ip disk_usage load newline context )
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=( status command_execution_time root_indicator background_jobs history time )
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
POWERLEVEL9K_CONTEXT_TEMPLATE=%n@%m%#
POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=true
POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=79

# Powerlevel9k colors {{{
POWERLEVEL9K_FOREGROUND_OK=silver
POWERLEVEL9K_BACKGROUND_OK=grey27
POWERLEVEL9K_FOREGROUND_WARN=white
POWERLEVEL9K_BACKGROUND_WARN=grey42
POWERLEVEL9K_FOREGROUND_ERROR=yellow1
POWERLEVEL9K_BACKGROUND_ERROR=darkred

POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_CONTEXT_SUDO_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
POWERLEVEL9K_CONTEXT_REMOTE_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}
POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_CONTEXT_REMOTE_SUDO_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}

POWERLEVEL9K_DIR_HOME_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_DIR_HOME_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
POWERLEVEL9K_DIR_ETC_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_DIR_ETC_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}

POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_LOAD_NORMAL_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
POWERLEVEL9K_LOAD_WARN_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
POWERLEVEL9K_LOAD_WARN_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}
POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}

POWERLEVEL9K_IP_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_IP_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}

POWERLEVEL9K_STATUS_OK_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_STATUS_OK_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
POWERLEVEL9K_STATUS_ERROR_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_STATUS_ERROR_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}

POWERLEVEL9K_VCS_CLEAN_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_VCS_CLEAN_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}

POWERLEVEL9K_HISTORY_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_HISTORY_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}

POWERLEVEL9K_TIME_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_TIME_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}

POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}

POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}

POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}

POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_DISK_USAGE_NORMAL_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
POWERLEVEL9K_DISK_USAGE_WARNING_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}
POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
POWERLEVEL9K_DISK_USAGE_CRITICAL_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}

POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}

POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}

# }}}

# Antigen config complete
antigen apply

# }}}
# {{{ Key bindings

# {{{ ZSH history-substring-search plugin

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

bindkey -M vicmd v edit-command-line    # Enables pressing ESC-v to open current command line in vi
bindkey -v                              # Set VI key bindings
bindkey '^ ' autosuggest-accept         # zsh-autosuggestion: Bind CTRL-<space> to accept suggestion

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

        . ~/bin/z.sh

        function precmd () {
            _z --add "$(pwd -P)"
        }
    ;;

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

        . ~/bin/z.sh

        function precmd () {
            _z --add "$(pwd -P)"
        }
    ;;
esac

# }}}
# {{{ GRC: Generic colorizer

GRC=$(which grc) 2>/dev/null
# Newer (1.11) version of grc package have these nice configs to use
if [[ -f /etc/grc.zsh ]]; then
    source /etc/grc.zsh
elif [[ "$TERM" != dumb ]] && [[ -x ${GRC} ]]; then
    alias colourify="$GRC -es --colour=auto"
    alias configure='colourify ./configure'
    alias diff='colourify diff'
    alias make='colourify make'
    alias gcc='colourify gcc'
    alias g++='colourify g++'
    alias as='colourify as'
    alias gas='colourify gas'
    alias ld='colourify ld'
    alias ps="colourify ps"
    alias netstat='colourify netstat'
    alias ping='colourify ping'
    alias traceroute='colourify /usr/sbin/traceroute'
fi

# }}}
# {{{ shell git prompt

# Used with bureau theme

#function git_prompt_info() {
#    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
#    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
#}

# }}}
# Umask {{{

# if you install packages with pip using sudo you should probably set the umask
# options in sudoers to 022 to revert this
umask 007

# }}}
# {{{ Environment variables

export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sbin:./
path+=/usr/local/go/bin
path+=~/src/flutter/bin
path+=~/.pub-cache/bin
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export LC_COLLATE="C"                   # Makes ls sort dotfiles first
export EDITOR="vim"
export PAGER="less"
export TERMINAL="gnome-terminal"
#export TZ=UTC+2
export DEFAULT_USER="${USER}"           # used for powerlevel9k zsh theme
# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"     # When using a solarized termcolors the default of 8 is mapped to a unreadable color, 244 is analgous to 8 in a 256 color term

# }}}
# {{{ Aliases

alias more="less"

alias ls='ls --color=auto --group-directories-first --classify'
alias l='ls'
alias ll='ls -l'
alias llh='ls -lh'
alias la='ls -A'
alias lla='ls -la'

# Ansible
alias ave='ansible-vault edit'
alias avv='ansible-vault view'
alias avc='ansible-vault encrypt'

alias gzip='nice gzip'
alias tar='nice tar'
alias xz='nice xz -T0'
alias zstd='nice zstd -T0'

alias make='nice make'

# }}}
