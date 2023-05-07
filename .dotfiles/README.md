# dotfiles

## Install

### curl

> curl https://raw.githubusercontent.com/sedlund/dotfiles/dev/.dotfiles/install.sh |  sh -

### wget

> wget -O- https://raw.githubusercontent.com/sedlund/dotfiles/dev/.dotfiles/install.sh |  sh -

## Build dev container

> cd ~/.dotfiles

### Using Podman

> REF=$(git log -1 --format=%H); podman build . --tag dotfiles:${REF} --tag dotfiles:latest

Run

> podman run -it --rm --name dotfiles dotfiles zsh

### Using Docker to build

> REF=$(git log -1 --format=%H); docker build . --file Containerfile --tag dotfiles:${REF} --tag dotfiles:latest

