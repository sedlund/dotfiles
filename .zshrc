# vim: et foldmethod=marker

# {{{ 🧩 Functions

typeset -TU NOT_INSTALLED not_installed ","
warn_not_installed() {
    [[ "${NOT_INSTALLED}" != "" ]] \
        && echo warn: ${NOT_INSTALLED} not installed
}

# }}}
# {{{ ⌚ Early config
# Set NIX paths early so zsh plugins will load for these tools
[[ -e ~/.nix-profile/etc/profile.d/nix.sh ]] && . ~/.nix-profile/etc/profile.d/nix.sh

# Do we like asdf really?
[[ -d ~/.asdf ]] \
    || git clone --depth 1 https://github.com/asdf-vm/asdf.git ~/.asdf

# }}}
# {{{ 🖊️EDITOR Config

export EDITOR=$(basename $(whence nvim vim vi | head -1))
case ${EDITOR} in
    nvim)
        alias vi=nvim
        [[ -d ~/.config/nvim ]] || bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/lunarvim/master/utils/installer/install.sh)
    ;;
    vim)
        alias vi=vim
    ;;
esac

# }}}
# {{{ 😮 Oh-My-ZSH Plugin manager
# http://github.com/ohmyzsh/ohmyzsh Oh-My-Zsh

# We are using ohmyzsh first as both Antigen and Znap are failing with
# completion commands from kubectl and others.

plugins=(
    asdf
    aws
    docker
    docker-compose
    git
    github
    kubectl
    pip
    python
    systemd
    tmux
)

[[ -r ~/.ssh/id_rsa ]] \
    && plugins+=ssh-agent \
    && zstyle :omz:plugins:ssh-agent lifetime 4h

source ~/.zsh/ohmyzsh/oh-my-zsh.sh

# }}}
# {{{ ⛔ DISABLED: ⚡️Znap! - ZSH plugin manager

# Znap: https://github.com/marlonrichert/zsh-snap

# FIXME Waiting on: https://github.com/marlonrichert/zsh-snap/issues/43
# Since both Antigen and Znap both have this issue, sticking with
# Antigen as it is more mature.  Bundles supports a DRY interface to list
# off each module and it will pull them in parallel and load them by default,
# has better cleanup as well.

#ZNAPDIR=~/.zsh/znap
#zstyle ':znap:*' git-dir ${ZNAPDIR}
#[[ -d ${ZNAPDIR} ]] || git clone https://github.com/marlonrichert/zsh-snap.git ${ZNAPDIR}
#source ${ZNAPDIR}/znap.zsh

#znap prompt agnoster/agnoster-zsh-theme

# List repos here to paralell pull
#znap clone \
#    https://github.com/romkatv/powerlevel10k
#
#znap source powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[ ! -f ~/.p10k.zsh ] || source ~/.p10k.zsh

#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# Do not use znap for ohmyzsh stuff it causes problems - use omz first for
# it's plugins, then use znap for external repos.
#znap source ohmyzsh/ohmyzsh

#znap source ohmyzsh/ohmyzsh lib/{directories,git,kubectl}
#znap source ohmyzsh/ohmyzsh plugins/git
#set -xv
#znap source ohmyzsh/ohmyzsh plugins/kubectl
#set +xv
#znap source Tarrasch/zsh-autoenv
#znap source zdharma/fast-syntax-highlighting
#znap source zdharma/history-search-multi-word
#znap source zsh-users/zsh-autosuggestions
#znap source zsh-users/zsh-completions
#znap source zsh-users/zsh-history-substring-search
#znap source zsh-users/zsh-syntax-highlighting
#
#znap eval trapd00r/LS_COLORS 'dircolors -b LS_COLORS'
#zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# plugin specific options to load before antigen apply
#[[ -r ~/.ssh/id_rsa ]] && zstyle :omz:plugins:ssh-agent agent-forwarding on

# Apply theme
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# }}}
# {{{ 💉 Antigen - ZSH Plugin Manager

[[ -d ~/.zsh/antigen ]] \
        || git clone --depth 1 https://github.com/zsh-users/antigen.git ~/.zsh/antigen

# ADOTDIR — This directory is used to store all the repo clones, your bundles,
# themes, caches and everything else Antigen requires to run smoothly. Defaults
# to $HOME/.antigen
ADOTDIR=~/.zsh

# Load
source ~/.zsh/antigen/antigen.zsh
# Load ohmyzsh - many plugins/themes require its core library
## We are already loaded above
#antigen use oh-my-zsh

# Bundles to use
antigen bundles << EOBUNDLES
    Tarrasch/zsh-autoenv
    zdharma/fast-syntax-highlighting
    zdharma/history-search-multi-word
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-syntax-highlighting
EOBUNDLES

# plugin specific options to load before antigen apply
# enabed above in OMZ setup
#[[ -r ~/.ssh/id_rsa ]] && zstyle :omz:plugins:ssh-agent agent-forwarding on

# Antigen config complete
antigen apply

# }}}
# {{{ 🎹 Key bindings

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
# {{{ 🌈 GRC: Generic colorizer

# FIXME - this seems outdated - maybe there is something newer.
# /etc/grc.zsh does not list all the configs in /usr/share/grc

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
else
    not_installed+="grc"
fi

# }}}
# 😷 Umask {{{

# If you install packages with pip using sudo you should probably set the umask
# options in sudoers to 022 to revert this:
# cat << EOF | /etc/sudoers.d/umask
# Defaults umask = 0022
# Defaults umask_override
# EOF
umask 007

# }}}
# {{{ 🌎 Environment variables

# Test for some common paths and add them to PATH if they exist
for p in \
    ~/bin \
    ~/src/flutter/bin \
    ~/.pub-cache/bin \
    /usr/lib/dart/bin \
    /usr/local/go/bin
do
    [[ -d "${p}" ]] && path+="${p}"
done

[[ -d ~/go ]] && export GOPATH=~/go && path+=~/go/bin

export LANG=en_US.UTF-8
export LC_COLLATE="C"                               # Makes ls sort dotfiles first

# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"     # When using a solarized termcolors the default of 8 is mapped to a unreadable color, 244 is analgous to 8 in a 256 color term

# }}}
# {{{ 🎭 Aliases

which less &>/dev/null && alias more=less; export PAGER=less

if [[ -x $(which lsd 2>/dev/null) ]]; then
    alias ls='lsd --group-dirs first --classify'
else
    not_installed+=lsd
    alias ls='ls --color=auto --group-directories-first --classify'
    [[ -x /usr/bin/dircolors ]] && eval $(dircolors ~/.dir_colors)
fi

alias l='ls'
alias lla='ls -la'
alias lld='ls -ld'

# Ansible
which ansible-vault &>/dev/null \
    && alias ave='ansible-vault edit' \
    && alias avv='ansible-vault view' \
    && alias avc='ansible-vault encrypt'

which apt &>/dev/null \
    && alias apt='sudo nice apt'

alias gzip='nice gzip'
alias tar='nice tar'
which xz &>/dev/null && alias xz='nice xz -T0'
which zstd &>/dev/null && alias zstd='nice zstd -T0'

which make &>/dev/null && alias make='nice make'

# Systemd
which systemctl &>/dev/null && alias s='sudo -E systemctl'
which journalctl &>/dev/null && alias j='sudo -E journalctl'

which batcat &>/dev/null && alias bat='batcat'

# Prefer podman container runtime interface`
export CRI=$(basename $(whence podman docker)) &&
    which butane &>/dev/null \
        || alias butane='${CRI} run -it --rm -v ${PWD}:/pwd -w /pwd quay.io/coreos/butane:release'

# https://github.com/zero88/gh-release-downloader - github release downloader
#amd64 builds only :P
#alias ghrd="docker run --rm -v /tmp:/tmp zero88/ghrd:latest"

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

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -d ~/.sdkman ]] && export SDKMAN_DIR=~/.sdkman
[[ -r ~/.sdkman/bin/sdkman-init.sh ]] && source ~/.sdkman/bin/sdkman-init.sh

# }}}
# {{{ 🔠 Prompt
case ${TERM} in
    *256color*|xterm*|rxvt*|Eterm|aterm|kterm|gnome*)

        # Apply theme early
        antigen theme romkatv/powerlevel10k

        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
          source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
        fi

        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ -f ~/.p10k-graphical.zsh ]] && source ~/.p10k-graphical.zsh
    ;;

    linux)
        antigen theme romkatv/powerlevel10k
        if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
          source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
        fi
        [[ -f ~/.p10k-console.zsh ]] && source ~/.p10k-console.zsh
    ;;

    *)
        # This is a OMZ ssh theme - loading OMZ twice seems to hang
        #antigen theme pure
    ;;
esac
# }}}


