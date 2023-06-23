continue=1

req=(bash tmux)
for p in ${req} ; do
  command -v ${p} &>/dev/null \
    || { echo FAIL: ${p} is required for tmux plugin manager
         echo All requirements: ${req}
         continue=0
  }
done
unset req

[[ continue == 1 ]] && {
  tp=~/.tmux/plugins
  tpm=~/.tmux/plugins/tpm
  [[ ! -d ${tpm} ]] \
    && git clone --depth 1  https://github.com/tmux-plugins/tpm ${tpm}

  # This script uses bash...
  # Install tmux plugins using tpm / <leader>-I install / <leader>-U to update

  mark=${tp}/.pluginsinstalled
  [[ ! -f ${mark} ]] \
    && ${tpm}/scripts/install_plugins.sh \
    && touch ${mark}

  znap source ohmyzsh/ohmyzsh plugins/tmux

  # Cleanup
  unset tp tpm mark

  # FIXME: this is broke - init doesnt continune
  # add tmux to the autostart array
  # autostart+=tmux
}
