# dotfiles

## Install

### curl

> curl https://raw.githubusercontent.com/sedlund/dotfiles/dev/.dotfiles/install.sh |  sh -

### wget

> wget -O- https://raw.githubusercontent.com/sedlund/dotfiles/dev/.dotfiles/install.sh |  sh -

## Build container

> cd ~/.dotfiles

### Podman

> podman build . -t dotfiles

### Docker

> docker build . -f Containerfile -t dotfiles

