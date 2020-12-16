# {{{ Antigen - ZSH plugin manager

# Antigen: https://github.com/zsh-users/antigen

test -d ~/.antigen \
    || git clone --branch master https://github.com/zsh-users/antigen.git ~/.antigen

# ADOTDIR — This directory is used to store all the repo clones, your bundles,
# themes, caches and everything else Antigen requires to run smoothly. Defaults
# to $HOME/.antigen
#ADOTDIR=~/.zsh/.antigen

# Load
source ~/.antigen/antigen.zsh

# Load ohmyzsh - many plugins/themes require its core library
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
    zdharma/fast-syntax-highlighting
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-syntax-highlighting
EOBUNDLES

# plugin specific options to load before antigen apply
test ! -r ~/.ssh/id_rsa && zstyle :omz:plugins:ssh-agent agent-forwarding on

# Apply theme
if [ "$TERM" = screen ]; then
    export TERM=screen-256color
elif [ "$TERM" = xterm ] || [ "$TERM" = linux ]; then
    export TERM=xterm-256color
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

antigen theme romkatv/powerlevel10k
#antigen theme bureau
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=( dir dir_writable vcs ip disk_usage load newline context )
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=( status command_execution_time root_indicator background_jobs history time )
#POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
#POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
#POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
#POWERLEVEL9K_CONTEXT_TEMPLATE=%n@%m%#
#POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=true
#POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=79

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Powerlevel9k colors {{{
#POWERLEVEL9K_FOREGROUND_OK=silver
#POWERLEVEL9K_BACKGROUND_OK=grey27
#POWERLEVEL9K_FOREGROUND_WARN=white
#POWERLEVEL9K_BACKGROUND_WARN=grey42
#POWERLEVEL9K_FOREGROUND_ERROR=yellow1
#POWERLEVEL9K_BACKGROUND_ERROR=darkred
#
#POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_CONTEXT_SUDO_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
#POWERLEVEL9K_CONTEXT_REMOTE_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}
#POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_CONTEXT_REMOTE_SUDO_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#
#POWERLEVEL9K_DIR_HOME_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_DIR_HOME_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#POWERLEVEL9K_DIR_ETC_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_DIR_ETC_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#
#POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_LOAD_NORMAL_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#POWERLEVEL9K_LOAD_WARN_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
#POWERLEVEL9K_LOAD_WARN_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}
#POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#
#POWERLEVEL9K_IP_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_IP_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#
#POWERLEVEL9K_STATUS_OK_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_STATUS_OK_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#POWERLEVEL9K_STATUS_ERROR_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_STATUS_ERROR_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#
#POWERLEVEL9K_VCS_CLEAN_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_VCS_CLEAN_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
#POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}
#POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#
#POWERLEVEL9K_HISTORY_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_HISTORY_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#
#POWERLEVEL9K_TIME_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_TIME_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#
#POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#
#POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#
#POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
#POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}
#
#POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_DISK_USAGE_NORMAL_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND=${POWERLEVEL9K_FOREGROUND_WARN}
#POWERLEVEL9K_DISK_USAGE_WARNING_BACKGROUND=${POWERLEVEL9K_BACKGROUND_WARN}
#POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}
#POWERLEVEL9K_DISK_USAGE_CRITICAL_BACKGROUND=${POWERLEVEL9K_BACKGROUND_ERROR}
#
#POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=${POWERLEVEL9K_FOREGROUND_OK}
#POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=${POWERLEVEL9K_BACKGROUND_OK}
#
#POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND=${POWERLEVEL9K_FOREGROUND_ERROR}

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
# {{{ Host specific settings

case `hostname -s` in

    'yul1')
        . ~/bin/z.sh

        function precmd () {
            _z --add "$(pwd -P)"
        }
    ;;

    'flip')
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
if [ -f /etc/grc.zsh ]; then
    source /etc/grc.zsh
elif [ "$TERM" != dumb ] && [ -x ${GRC} ]; then
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

path+=:./
path+=~/src/flutter/bin
path+=~/.pub-cache/bin
path+=/usr/lib/dart/bin
path+=~/go/bin

manpath+=/usr/local/man

export LANG=en_US.UTF-8
export LC_COLLATE="C"                   # Makes ls sort dotfiles first
export EDITOR="vim"
export PAGER="less"
export TERMINAL="gnome-terminal"
export DEFAULT_USER="${USER}"           # used for powerlevel9k zsh theme
# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"     # When using a solarized termcolors the default of 8 is mapped to a unreadable color, 244 is analgous to 8 in a 256 color term
test -d ~/go && export GOPATH=~/go

# }}}
# {{{ Aliases

alias more="less"

which lsd > /dev/null \
    && alias ls='lsd --group-dirs first --classify' \
    || alias ls='ls --color=auto --group-directories-first --classify'

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
which batcat > /dev/null && alias bat='batcat'

cosa() {
   env | grep COREOS_ASSEMBLER
   set -x
   podman run --rm -ti --security-opt label=disable --privileged                                    \
              --uidmap=1000:0:1 --uidmap=0:1:1000 --uidmap 1001:1001:64536                          \
              -v ${PWD}:/srv/ --device /dev/kvm --device /dev/fuse                                  \
              --tmpfs /tmp -v /var/tmp:/var/tmp --name cosa                                         \
              ${COREOS_ASSEMBLER_CONFIG_GIT:+-v $COREOS_ASSEMBLER_CONFIG_GIT:/srv/src/config/:ro}   \
              ${COREOS_ASSEMBLER_GIT:+-v $COREOS_ASSEMBLER_GIT/src/:/usr/lib/coreos-assembler/:ro}  \
              ${COREOS_ASSEMBLER_CONTAINER_RUNTIME_ARGS}                                            \
              ${COREOS_ASSEMBLER_CONTAINER:-quay.io/coreos-assembler/coreos-assembler:latest} "$@"
   rc=$?; set +x; return $rc
}

# }}}
