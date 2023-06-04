FROM alpine:edge

# lsd is in testing repo
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update

# Base
RUN apk add zsh git bash

# LunarVim requirements
RUN apk add neovim make py3-pip npm fd ripgrep fzf gcc musl-dev

# For testing .vimrc for systems that packages cannot be installed
RUN apk add vim

# tools
RUN apk add curl lsd openssh tmux

# Run as root
# required for usermod
# RUN apk add shadow
# RUN usermod -s /bin/zsh root
# WORKDIR /root
# ADD --chmod=770 install.sh /root

# Run as user
RUN apk add sudo
RUN echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel_nopasswd
RUN adduser -D -s /bin/zsh user
# required for usermod
RUN apk add shadow
RUN usermod -aG wheel user
USER user
WORKDIR /home/user
ADD --chown=user:user --chmod=770 install.sh /home/user

RUN ./install.sh

# Run initial zsh setup
RUN zsh ~/.zshrc
RUN zsh -i

# Run lvim to install initial plugins to make container imutable
RUN ~/.local/bin/lvim -es
# Run vim to install initial plugins to make container imutable
RUN vim -q | true

CMD [ "/bin/zsh" ]

