# dotfiles

## Install

### wget

> wget -O- https://raw.githubusercontent.com/sedlund/dotfiles/dev/.dotfiles/install.sh |  sh -

## Build testing image

> cd ~/.dotfiles

### Using Podman

> REF=$(git log -1 --format=%H); podman build . --tag dotfiles-testing:${REF} --tag dotfiles-testing:latest

Run

> podman run -it --rm --name dotfiles dotfiles zsh

### Using Docker to build

> REF=$(git log -1 --format=%H); docker build . --file Containerfile --tag dotfiles-testing:${REF} --tag dotfiles-testing:latest

## Build development image

I use this image as a development environment, it has additional tools that I
use that are not required for testing dotfiles deployment.  It's built from
the above `dotfiles-testing` image.

> REF=$(git log -1 --format=%H); podman build . --file Containerfile.devbox --tag dotfiles-dev:${REF} --tag dotfiles-dev:latest

