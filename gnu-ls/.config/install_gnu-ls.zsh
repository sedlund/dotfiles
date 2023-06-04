for p in coreutils; do
  command -v ${p} &>/dev/null \
  || {
    echo FAIL: ${p} is required for gnu-ls dir_colors
    exit 1
  }
done

alias ls='ls --color=auto --group-directories-first -F'

# dircolors is in coreutils on alpine
command -v dircolors &>/dev/null && eval $(dircolors ~/.dir_colors)

