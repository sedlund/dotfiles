# dotfiles

> cd; git clone https://github.com/sedlund/dotfiles .

Or, if you have a current home directory:

```shell
cd; git clone --recurse-submodules https://github.com/sedlund/dotfiles
cp -a dotfiles/. .
rm -rf dotfiles
git reset --hard
git config --local status.showuntrackedfiles no
```

