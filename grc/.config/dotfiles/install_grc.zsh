
command -v grc &> /dev/null \ || {
  echo "Press return to install GRC in your home, CTRL-C to cancel and install via the package manager"
  read
  echo "Installing generic colouriser (grc)"
  d=$(mktemp -d)
  git clone --depth 1 https://github.com/garabik/grc.git ${d}
  pushd
  cd ${d}
  ./install.sh ~/.local ~/.local
  cp _grc ~/.local/share/zsh/site-functions
  mkdir -p ~/.config/grc
  cp grc.conf ~/.config/grc
  rm -rf ~/.local/share/etc
  popd
  rm -rf ${d}
  unset d
}


if [[ -r /etc/grc.zsh ]] || [[ -r ~/.local/etc/grc.zsh ]]; then
  for cmd in $(/bin/ls /usr/share/grc ~/.local/share/grc 2>/dev/null | grep -vE "ls" | cut -d. -f2); do
    if (( $+commands[$cmd] )); then
      $cmd() { grc --colour=auto ${commands[$0]} "$@" }
    fi
  done
  # some commands don't work with grc / kubectl completions break
  for cmd in mtr systemctl; do
    # TODO: maybe check if it exists before unfunction
    unfunction ${cmd} 2>/dev/null
  done
else
  not_installed+="grc"
fi

unset cmd
