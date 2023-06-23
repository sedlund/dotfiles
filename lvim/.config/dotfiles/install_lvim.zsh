# vim: foldmethod=marker

# theres probably a better way to do this, but it escapes me right now...
continue=1

req=(nvim npm python3 gcc bash make fd rg fzf)
for p in ${req} ; do
  command -v ${p} &>/dev/null || {
    echo FAIL: ${p} is required for lvim
    echo All requirements: ${req}
    continue=0
  }
done
unset req

# initial lvim stow will symlink the directory which will cause lvim during
# install to put the lazy-lock file in our dotfiles. so test if the directory
# is a link, if so delete it and make a directory
[[ ${continue} == 1 ]] && {

  lvcd="$HOME/.config/lvim"
  [[ -L "${lvcd}" ]] || {
    rm "${lvcd}" &>/dev/null
    mkdir -p ~/.config/lvim &> /dev/null
  }
  unset lvcd

  # Install lvim
  # https://www.lunarvim.org/docs/installation
  command -v lvim &>/dev/null || {
    echo Installing Lunarvim...
    LV_BRANCH='release-1.3/neovim-0.9' \
    bash <(wget -O- https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) -y
  }

  # the installer removes our config from the initial stow
  cfg="$HOME/.config/lvim/config.lua"
  [[ -L "${cfg}" ]] || {
    rm "${cfg}" &> /dev/null
    stow --dir ~/.dotfiles --target $HOME lvim
  }
  unset cfg

}

unset continue
