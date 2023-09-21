# Ubuntu wants to run compinit in /etc/zsh/zshrc
skip_global_compinit=1
[ -f ~/.cargo/env ] && . ~/.cargo/env

if [ -e /home/pi/.nix-profile/etc/profile.d/nix.sh ]; then . /home/pi/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
