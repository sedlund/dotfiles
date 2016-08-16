dotfiles
========

    $ cd; git clone https://github.com/sedlund/dotfiles .

Or if you have a current homedir

    $ cd; git clone https://github.com/sedlund/dotfiles.git tmp && mv tmp/.git . && rm -rf tmp && git reset --hard

After the above pull submodules

    $ git submodule update --recursive --init
