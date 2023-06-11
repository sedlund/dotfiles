# shellcheck shell=zsh
# vim: expandtab foldmethod=marker

# {{{ ⌚ Profile - Start

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

# }}}
# {{{ 🧩 Functions

typeset -TU NOT_INSTALLED not_installed ","
warn_not_installed() {
  [[ "${NOT_INSTALLED}" != "" ]] \
    && echo warn: "${NOT_INSTALLED}" not installed
}

# }}}
# {{{ 🌅 Early config

# 😷 Umask {{{

# If you install packages with pip using sudo you should probably set the umask
# options in sudoers to 022 to revert this:
# cat << EOF | /etc/sudoers.d/umask
# Defaults umask = 0022
# Defaults umask_override
# EOF
umask 007

# }}}

# Dont allow overwriting files by default
set -o noclobber

# Set NIX paths early so zsh plugins will load for these tools
[[ -e ~/.nix-profile/etc/profile.d/nix.sh ]] \
  && . ~/.nix-profile/etc/profile.d/nix.sh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# }}}
# {{{ 🌎 Environment variables

# save original system path
opath=("${path[@]}")

# dont error on failed globs in the for loop below (~)
setopt NULL_GLOB

typeset -a npath
# Test for common paths, add them to PATH in order of precedence
for p in \
  ./ \
  ~/.arkade/bin \
  ~/.asdf/shims \
  ~/.asdf/installs/krew/*/bin \
  ~/.cargo/bin \
  ~/.pub-cache/bin \
  ~/.local/bin \
  ~/bin \
  ~/src/flutter/bin \
  ~/go/bin \
  /usr/lib/cargo/bin \
  /usr/lib/dart/bin \
  /usr/local/go/bin \
  /usr/local/bin \
  /usr/bin \
  /bin \
  /usr/sbin \
  /sbin
do
  [[ -d ${p} ]] && npath+=("${p}")
done
unsetopt NULL_GLOB

# remove original path
unset path

# add system path to the end
path=("${npath[@]}" "${opath[@]}")
unset npath opath

# set GOPATH
[[ -d ~/go ]] && export GOPATH=~/go

export LANG=en_US.UTF-8
export LC_COLLATE="C"                           # Makes ls sort dotfiles first

# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
# When using a solarized termcolors the default of 8 is mapped to a unreadable
# color, 244 is analgous to 8 in a 256 color term
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# }}}
# {{{ 🎭 Aliases

# {{{ 🖊 EDITOR Config

# In the order of preference - stops after first found
for cmd in lvim nvim vim vi; do
  if (( ${+commands[$cmd]} )); then
    case $cmd in
      lvim)
      # Sanity check if running a restored homedir on a OS without neovim
      if (( ${+commands[nvim]} )); then
         export EDITOR=$cmd
         alias vi=$cmd
      else
        not_installed+=neovim
      fi
      ;;
      nvim)
        alias vi=lvim
        export EDITOR=$cmd
        # Fallback to vim if we dont have the requisuites for lunarvim
        if (( $+commands[vim] )); then
          alias vi=vim
          export EDITOR=vim
        else
          export EDITOR=$cmd
          alias vi=$cmd
        fi
      ;;
      vim)
        export EDITOR=$cmd
        alias vi=$cmd
        not_installed+=neovim
      ;;
      vi)
        export EDITOR=$cmd
        not_installed+=neovim
      ;;
    esac
    # stop after first loop
    break
  fi
done

# }}}

# FIXME: create array of commands that are individually specified below and
# wrap in a case statement like above (maybe?)

# Test for lsd here so we can warn on it missing before znap init
command -v lsd &>/dev/null || not_installed+="lsd"

command -v less &>/dev/null && alias more=less; export PAGER=less

# Ansible
command -v ansible-vault &>/dev/null \
  && alias ave='ansible-vault edit' \
  && alias avv='ansible-vault view' \
  && alias avc='ansible-vault encrypt'

which apt &>/dev/null \
  && alias apt='sudo nice apt'

which dnf &>/dev/null \
  && alias dnf='sudo nice dnf'

# Fedora Toolbox
[ "$(hostname)" = "toolbox" ] \
  && alias podman='flatpak-spawn --host podman'

alias gzip='nice gzip'
alias tar='nice tar'
which xz &>/dev/null && alias xz='nice xz -T0' || not_installed+="xz"
which zstd &>/dev/null && alias zstd='nice zstd -T0' || not_installed+="zstd"

which make &>/dev/null && alias make='nice make' || not_installed+="make"

# Systemd

which systemctl &>/dev/null && alias s="sudo systemctl"
which journalctl &>/dev/null && alias j="sudo journalctl"

which fd &>/dev/null || not_installed+="fd-find"

# disable color codes from rendered man pages for bat
export MANROFFOPT="-c"

# debian
which batcat &>/dev/null \
  && { alias bat=batcat
       export MANPAGER="sh -c 'col -bx | $(whence batcat) --language man --plain'"
     }

# use short options for col as raspbian col doesnt have long options

# fedora / asdf
which bat &>/dev/null \
  && export MANPAGER="sh -c 'col -bx | $(whence bat) --language man --plain'"

# Prefer podman CRI (container runtime interface)
CRI=$(basename "$(whence podman docker)" 2>/dev/null)
if ! command -v butane &>/dev/null && command -v "${CRI}" &>/dev/null; then
  alias butane='${CRI} run -it --rm -v ${PWD}:/pwd -w /pwd quay.io/coreos/butane:release'
fi

# }}}
# {{{ ⚡Znap! - ZSH plugin manager

# Znap: https://github.com/marlonrichert/zsh-snap

# These are normally set by oh-my-zsh.  We don't load all of it so set it here.
ZSH=~/.zsh/ohmyzsh
ZSH_CACHE_DIR=$ZSH/cache
# ohmyzsh puts completions here, since we do not init omz we make them
[[ ! -x ${ZSH_CACHE_DIR}/completions ]] && mkdir ${ZSH_CACHE_DIR}/completions
# add to zsh completion path
fpath+=${ZSH_CACHE_DIR}/completions

ZNAPDIR=~/.zsh/znap
[[ -d ${ZNAPDIR} ]] \
    || git clone --branch 22.06.22 https://github.com/marlonrichert/zsh-snap.git ${ZNAPDIR}
source ${ZNAPDIR}/znap.zsh

#znap prompt agnoster/agnoster-zsh-theme

# List repos here to paralell pull
znap clone https://github.com/romkatv/powerlevel10k.git

znap source ohmyzsh/ohmyzsh lib/{git,completion,theme-and-appearance,directories,history}
znap source ohmyzsh/ohmyzsh plugins/asdf
znap source ohmyzsh/ohmyzsh plugins/git
# ssh-agent should only run on hosts that will serve keys, not clients
[[ -r ~/.ssh/id_ed25519 ]] && znap source ohmyzsh/ohmyzsh plugins/ssh-agent
znap source ohmyzsh/ohmyzsh plugins/vi-mode
command -v pip &>/dev/null && znap source ohmyzsh/ohmyzsh plugins/pip
znap source Tarrasch/zsh-autoenv
znap source ohmyzsh/ohmyzsh plugins/terraform
znap source zdharma-continuum/fast-syntax-highlighting
znap source zdharma-continuum/history-search-multi-word
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-history-substring-search
# znap source zsh-users/zsh-syntax-highlighting

command -v kubectl &>/dev/null \
  && znap source ohmyzsh/ohmyzsh plugins/kubectl

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  not_installed+="zoxide"
fi

# FIXME: zsh does this now
# cache completions
#sf=~/.local/share/zsh/site-functions
#for cmd in \
#  hcloud \
#  podman
#do
#  if [[ command -v ${cmd} &>/dev/null) ]]; then
#    if [[ ! -f ${sf}/_${cmd} ]]; then
#      ${cmd} completion zsh > ${sf}/_${cmd}
#    fi
#  fi
#done

#znap eval trapd00r/LS_COLORS 'dircolors -b LS_COLORS'
#zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# {{{ 📜 ls config

if command -v lsd &>/dev/null; then
  alias ls='lsd --group-dirs first --classify'
else
  not_installed+="lsd"
  # use -F instead of --classify to appease busybox
  # alias ls='ls --color=auto --group-directories-first -F'
  # # dircolors is in coreutils on alpine
  # command -v dircolors &>/dev/null && eval $(dircolors ~/.dir_colors)
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
  *256color*|xterm*|rxvt*|Eterm|alacritty|aterm|contour|kterm|gnome*)
    # Apply theme early
    znap source powerlevel10k

    # Enable Powerlevel10k instant prompt. Should stay close to the top of
    # ~/.zshrc. Initialization code that may require console input (password
    # prompts, [y/n] confirmations, etc.) must go above this block; everything
    # else may go below.
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ -f ~/.zsh/p10k/p10k-graphical.zsh ]] && source ~/.zsh/p10k/p10k-graphical.zsh
  ;;

  linux)
    # Apply theme early
    znap source powerlevel10k

    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
    [[ -f ~/.zsh/p10k/p10k-console.zsh ]] && source ~/.zsh/p10k/p10k-console.zsh
  ;;

  *)
    # This is a OMZ theme - loading OMZ twice seems to hang
    znap prompt agnoster/agnoster-zsh-theme
  ;;
esac

# }}}

# }}}
# # {{{ 🔧 Install tools from ~/.config/dotfiles

# an array of functions to run at the end of init
# the dotfile configs can create a function and add it here
typeset -a autostart
# FIXME:eventually each module will add their paths to this array and will be
# prepended to the default system path
# array of my paths to add
typeset -a mpath
# Should occur after znap init as we can load the tools plugin in the script
setopt NULL_GLOB
for f in ~/.config/dotfiles/*; do
  test -f "$f" || continue
  source "${f}"
done
unsetopt NULL_GLOB

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
# Enable pressing ESC-v to open current command line in vi
bindkey -M vicmd v edit-command-line
# Set VI key bindings
bindkey -v
# zsh-autosuggestion: Bind CTRL-<space> to accept suggestion
bindkey '^ ' autosuggest-accept

[[ -x /usr/local/bin/aws_completer ]] \
  && complete -C '/usr/local/bin/aws_completer' aws

warn_not_installed

# }}}
# {{{ ⌚ Profile - Stop

# unsetopt XTRACE
# exec 2>&3 3>&-

# zprof

# }}}
# {{{ 🏃 Autostart

# FIXME: Obviously this isn't well implemented yet
for cmd in "${autostart[@]}"; do
  ${cmd}
done

# }}}
