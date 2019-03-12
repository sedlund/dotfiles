dotfiles
========

## 1.

    $ cd; git clone https://github.com/sedlund/dotfiles .

Or, if you have a current home directory:

    $ cd; git clone https://github.com/sedlund/dotfiles.git tmp && \
      mv tmp/.git . && \
      rm -rf tmp && \
      git reset --hard

## 2.

This project uses git submodules, so pull them separately:

    $ git submodule update --recursive --init
