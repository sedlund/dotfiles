#!/usr/bin/env sh

for req in git stow; do
  command -v ${req} &> /dev/null \
    || { echo "FAIL: $req is required to install"
         exit 1
       }

cd \
  && git clone \
       https://github.com/sedlund/dotfiles.git ~/.dotfiles

# FIXME: break out scripts from dotfiles
# stow will symlink the bin dir if it doesnt exist prior to run
mkdir ~/bin \
  && touch ~/bin/.notempty

