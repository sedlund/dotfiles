
__install_fonts() {

	[[ -d ~/.local/share/fonts ]] && {
		continue
	}

	cd ~/.local/share/fonts
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip
	unzip Meslo.zip
	rm Meslo.zip
}

__install_fonts
