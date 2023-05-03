# dotfiles

```shell
cd && git clone --recurse-submodules https://github.com/sedlund/dotfiles.git
cp --recursive dotfiles/. . && rm --recursive dotfiles
git reset --hard
git config --local status.showuntrackedfiles no
```

