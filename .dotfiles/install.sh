#!/usr/bin/env sh

cd \
  && git clone --recurse-submodules https://github.com/sedlund/dotfiles.git

# busybox compliant flags
cp -r dotfiles/. . \
  && rm -r dotfiles

git reset --hard

git config --local status.showuntrackedfiles no

~/.tmux/plugins/tpm/scripts/install_plugins.sh

