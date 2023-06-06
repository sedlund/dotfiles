
# Do we like asdf really?
[[ -d ~/.asdf ]] \
    || { echo Installing asdf...
         git clone --depth 1 https://github.com/asdf-vm/asdf.git ~/.asdf
         echo Restart your shell (exec zsh) to have asdf in path
}

mpath+=~/.asdf/shims
