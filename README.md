# dotfiles

## Step 1

    $ cd; git clone <https://github.com/sedlund/dotfiles> .

Or, if you have a current home directory:

```shell
$ cd; git clone https://github.com/sedlund/dotfiles.git && \\
  cp -a dotfiles/. . && \\
  rm -rf dotfiles && \\
  git reset --hard
```

## Step 2

This project uses git submodules, so pull them separately:

    $ git submodule update --recursive --init
