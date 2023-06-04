req=(nvim npm python3 gcc bash make fd rg fzf)
for p in ${req} ; do
  command -v ${p} &>/dev/null \
    || { echo FAIL: ${p} is required for lvim
         echo All requirements: ${req}
         exit 1
  }
done

# Install lvim
# https://www.lunarvim.org/docs/installation
echo Installing Lunarvim...

# initial lvim stow will symlink the directory which will cause lvim during
# install to put the lazy-lock file in our dotfiles. so test if the directory
# is a link, if so delete it and make a directory
lvcd="$HOME/.config/lvim"
[[ -L "${lvcfg}" ]] \
  || { rm "${lvcd}" &>/dev/null
       mkdir -p ~/.config/lvim &> /dev/null
}

command -v lvim \
  || LV_BRANCH='release-1.3/neovim-0.9' \
     bash <(wget -O- https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) -y

# the installer removes our config from the initial stow
cfg="$HOME/.config/lvim/config.lua"
[[ -L "${cfg}" ]] \
  || { rm "${cfg}" &> /dev/null
       stow --dir ~/.dotfiles --target $HOME lvim
}

# Cleanup
unset req lvcd cfg
