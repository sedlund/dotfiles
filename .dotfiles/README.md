# dotfiles

## Install

### curl

> curl https://raw.githubusercontent.com/sedlund/dotfiles/dev/.dotfiles/install.sh |  sh -

### wget

> wget -O- https://raw.githubusercontent.com/sedlund/dotfiles/dev/.dotfiles/install.sh |  sh -

## Build dev container

> cd ~/.dotfiles

### Using Podman

> podman build . --tag dotfiles

Run

> podman run -it --rm --name dotfiles dotfiles zsh

### Using Docker to build

> docker build . --file Containerfile --tag dotfiles

