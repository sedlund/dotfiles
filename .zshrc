# vim: et foldmethod=marker

#{{{ Profile - Start
# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '
#
# logfile=$(mktemp zsh_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile
#
# setopt XTRACE

# zmodload zsh/zprof

#}}}
# {{{ 🧩 Functions

typeset -TU NOT_INSTALLED not_installed ","
warn_not_installed() {
    [[ "${NOT_INSTALLED}" != "" ]] \
        && echo warn: ${NOT_INSTALLED} not installed
}

# }}}
# {{{ ⌚ Early config

# 😷 Umask {{{

# If you install packages with pip using sudo you should probably set the umask
# options in sudoers to 022 to revert this:
# cat << EOF | /etc/sudoers.d/umask
# Defaults umask = 0022
# Defaults umask_override
# EOF
umask 007

# }}}

# Set NIX paths early so zsh plugins will load for these tools
[[ -e ~/.nix-profile/etc/profile.d/nix.sh ]] && . ~/.nix-profile/etc/profile.d/nix.sh

# Do we like asdf really?
[[ -d ~/.asdf ]] \
    || git clone --depth 1 https://github.com/asdf-vm/asdf.git ~/.asdf

# }}}
# {{{ 🌎 Environment variables

# Test for some common paths and add them to PATH if they exist
for p in \
    ~/.asdf/shims \
    ~/.pub-cache/bin \
    ~/bin \
    ~/src/flutter/bin \
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

# {{{ 🖊 EDITOR Config

for cmd in lvim nvim vim vi; do
    if (( $+commands[$cmd] )); then
        case ${EDITOR} in
            lvim)
                EDITOR=$cmd
                alias vi=lvim
            ;;
            nvim)
                alias
                if (( $+commands[pip3] )); then
                    [[ -d ~/.local/share/lunarvim ]] \
                        || bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/lunarvim/master/utils/installer/install.sh)
                    alias vi=lvim
                    EDITOR=$cmd
                fi
                # Fallback to vim if we dont have the requisuites for lunarvim
                alias vi=vim
                EDITOR=vim
            ;;
            vim)
                alias vi=vim
            ;;
        esac
        break
    fi
done

# }}}

# Test for lsd here so we can warn on it missing before znap init
[[ -x $(which lsd 2>/dev/null) ]] || not_installed+="lsd"

which less &>/dev/null && alias more=less; export PAGER=less

# Ansible
which ansible-vault &>/dev/null \
    && alias ave='ansible-vault edit' \
    && alias avv='ansible-vault view' \
    && alias avc='ansible-vault encrypt'

which apt &>/dev/null \
    && alias apt='sudo nice apt'

alias gzip='nice gzip'
alias tar='nice tar'
which xz &>/dev/null && alias xz='nice xz -T0' || not_installed+="xz"
which zstd &>/dev/null && alias zstd='nice zstd -T0' || not_installed+="zstd"

which make &>/dev/null && alias make='nice make'

# Systemd
which systemctl &>/dev/null && alias s='sudo -E systemctl'
which journalctl &>/dev/null && alias j='sudo -E journalctl'

which batcat &>/dev/null && alias bat="batcat"
which bat &>/dev/null || not_installed+="bat"

which kubectl &>/dev/null && alias k=kubectl || not_installed+="kubectl"

# Prefer podman container runtime interface
export CRI=$(basename $(whence podman docker) 2>/dev/null)
if [[ -x $(which ${CRI} 2>/dev/null) ]]; then
    which butane &>/dev/null \
        || alias butane='${CRI} run -it --rm -v ${PWD}:/pwd -w /pwd quay.io/coreos/butane:release'
fi

# https://github.com/zero88/gh-release-downloader - github release downloader
#amd64 builds only :P
#alias ghrd="docker run --rm -v /tmp:/tmp zero88/ghrd:latest"

# }}}
# {{{ ⛔ DISABLED: 😮 Oh-My-ZSH Plugin manager
# http://github.com/ohmyzsh/ohmyzsh Oh-My-Zsh

# We are using ohmyzsh first as both Antigen and Znap are failing with
# completion commands from kubectl and others.

# plugins=(
#     asdf
#     aws
#     docker
#     docker-compose
#     git
#     github
#     kubectl
#     python
#     systemd
# )
# 
# [[ -x $(which tmux 2>/dev/null) ]] && plugins+=tmux
# [[ -x $(which pip 2>/dev/null) ]] && plugins+=pip
# 
# [[ -r ~/.ssh/id_rsa ]] \
#     && plugins+=ssh-agent \
#     && zstyle :omz:plugins:ssh-agent lifetime 4h
# 
# source ~/.zsh/ohmyzsh/oh-my-zsh.sh

# }}}
# {{{ ⚡Znap! - ZSH plugin manager

# Znap: https://github.com/marlonrichert/zsh-snap

# These are normally set by oh-my-zsh.  We don't load all of it so set it here.
ZSH=~/.zsh/ohmyzsh
ZSH_CACHE_DIR=$ZSH/cache

ZNAPDIR=~/.zsh/znap
[[ -d ${ZNAPDIR} ]] \
    || git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ${ZNAPDIR}
source ${ZNAPDIR}/znap.zsh

#znap prompt agnoster/agnoster-zsh-theme

# List repos here to paralell pull
znap clone \
    https://github.com/romkatv/powerlevel10k

znap source ohmyzsh/ohmyzsh lib/{git,completion,theme-and-appearance,directories,history}
# znap source ohmyzsh/ohmyzsh lib/{completion,theme-and-appearance,directories}
znap source ohmyzsh/ohmyzsh plugins/asdf
znap source ohmyzsh/ohmyzsh plugins/git
[[ -x $(which tmux 2>/dev/null) ]] && znap source ohmyzsh/ohmyzsh plugins/tmux
[[ -x $(which pip 2>/dev/null) ]] && znap source ohmyzsh/ohmyzsh plugins/pip
# znap source ohmyzsh/ohmyzsh plugins/kubectl
znap source ohmyzsh/ohmyzsh plugins/terraform
znap source Tarrasch/zsh-autoenv
znap source zdharma/fast-syntax-highlighting
znap source zdharma/history-search-multi-word
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-history-substring-search
znap source zsh-users/zsh-syntax-highlighting

znap compdef _kubectl 'kubectl completion zsh'

znap source rupa/z
#znap eval trapd00r/LS_COLORS 'dircolors -b LS_COLORS'
#zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# plugin specific options to load before antigen apply
#[[ -r ~/.ssh/id_rsa ]] && zstyle :omz:plugins:ssh-agent agent-forwarding on

# {{{ 📜 ls config

if [[ -x $(which lsd 2>/dev/null) ]]; then
    alias ls='lsd --group-dirs first --classify'
else
    not_installed+="lsd"
    alias ls='ls --color=auto --group-directories-first --classify'
    [[ -x $(which dircolors 2>/dev/null) ]] && eval $(dircolors ~/.dir_colors)
fi

# This overwrides ls aliases of ohmyzsh/ohmyzsh/libs{directories} that I prefer
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias l1='ls -1'
alias lla='ls -lah'
alias lld='ls -ldh'

# }}}

# {{{ 🔠 Prompt
case ${TERM} in
    *256color*|xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
        # Apply theme early
        znap source powerlevel10k

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
        # Apply theme early
        znap source powerlevel10k

        if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
            source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
        fi
        [[ -f ~/.p10k-console.zsh ]] && source ~/.p10k-console.zsh
    ;;

    *)
        # This is a OMZ ssh theme - loading OMZ twice seems to hang
        znap prompt agnoster/agnoster-zsh-theme
    ;;
esac

# }}}

# }}}
# {{{ 🌈 GRC: Generic colorizer

if [[ -r /etc/grc.zsh ]]; then
    for cmd in $(/bin/ls /usr/share/grc | cut -d. -f2); do
        if (( $+commands[$cmd] )); then
            $cmd() { grc --colour=auto ${commands[$0]} "$@" }
        fi
    done
else
    not_installed+="grc"
fi

# }}}
# {{{ ⛔ DISABLED: 💉 Antigen - ZSH Plugin Manager

# [[ -d ~/.zsh/antigen ]] \
#         || git clone --depth 1 https://github.com/zsh-users/antigen.git ~/.zsh/antigen
# 
# # ADOTDIR — This directory is used to store all the repo clones, your bundles,
# # themes, caches and everything else Antigen requires to run smoothly. Defaults
# # to $HOME/.antigen
# ADOTDIR=~/.zsh
# 
# # Load
# source ~/.zsh/antigen/antigen.zsh
# # Load ohmyzsh - many plugins/themes require its core library
# ## We are already loaded above
# #antigen use oh-my-zsh
# 
# # Bundles to use
# antigen bundles << EOBUNDLES
#     Tarrasch/zsh-autoenv
#     zdharma/fast-syntax-highlighting
#     zdharma/history-search-multi-word
#     zsh-users/zsh-autosuggestions
#     zsh-users/zsh-completions
#     zsh-users/zsh-history-substring-search
#     zsh-users/zsh-syntax-highlighting
# EOBUNDLES
# 
# # plugin specific options to load before antigen apply
# # enabed above in OMZ setup
# # Disabled to use default 4h timeout
# #[[ -r ~/.ssh/id_rsa ]] && zstyle :omz:plugins:ssh-agent agent-forwarding on
# 
# # {{{ 🔠 Prompt
# case ${TERM} in
#     *256color*|xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
# 
#         # Apply theme early
#         antigen theme romkatv/powerlevel10k
# 
#         # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
#         # Initialization code that may require console input (password prompts, [y/n]
#         # confirmations, etc.) must go above this block; everything else may go below.
#         if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#           source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#         fi
# 
#         # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#         [[ -f ~/.p10k-graphical.zsh ]] && source ~/.p10k-graphical.zsh
#     ;;
# 
#     linux)
#         antigen theme romkatv/powerlevel10k
#         if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#           source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#         fi
#         [[ -f ~/.p10k-console.zsh ]] && source ~/.p10k-console.zsh
#     ;;
# 
#     *)
#         # This is a OMZ ssh theme - loading OMZ twice seems to hang
#         #antigen theme pure
#     ;;
# esac
# 
# # }}}
# 
# # Antigen config complete
# antigen apply

# }}}
# {{{ 🎹 Key bindings - Load after ZSH Plugin Manager(s)

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

[[ -x /usr/local/bin/aws_completer ]] && complete -C '/usr/local/bin/aws_completer' aws
warn_not_installed

# }}}
#{{{ Profile - Stop

# unsetopt XTRACE
# exec 2>&3 3>&-

# zprof

#}}}

