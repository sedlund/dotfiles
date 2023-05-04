#!/usr/bin/env bash

cd \
  && git clone --recurse-submodules https://github.com/sedlund/dotfiles.git

# busybox compliant flags
cp -r dotfiles/. . \
  && rm -r dotfiles

git reset --hard

git config --local status.showuntrackedfiles no

# Install tmux plugins using tpm / <leader>-I install / <leader>-U update
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install lvim
# https://www.lunarvim.org/docs/installation
LV_BRANCH='release-1.3/neovim-0.9' \
    bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) -y

# the installer moves our config from the initial checkout
git checkout ~/.config/lvim/config.lua

