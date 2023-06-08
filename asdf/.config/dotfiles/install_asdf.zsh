
# Do we like asdf really?
[[ -d ~/.asdf ]] \
    || { echo Installing asdf...
         git clone --depth 1 https://github.com/asdf-vm/asdf.git ~/.asdf
         echo
         echo Restart your shell to have asdf in path
}

mpath+=~/.asdf/shims
