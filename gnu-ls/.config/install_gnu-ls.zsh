continue=1

for p in coreutils; do
  command -v ${p} &>/dev/null || {
    echo FAIL: ${p} is required for gnu-ls dir_colors
    continue=0
  }
done

[[ continue == 1 ]] && {
  alias ls='ls --color=auto --group-directories-first -F'

  # dircolors is in coreutils on alpine
  command -v dircolors &>/dev/null && eval $(dircolors ~/.dir_colors)
}

unset continue

