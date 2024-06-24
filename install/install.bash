#!/bin/bash
#* Command to fetch and run install script
#* bash -c "$(curl -fsSL https://raw.githubusercontent.com/Sargates/.zshconfig/master/install/install.bash)"
#* bash -c "$(wget https://raw.githubusercontent.com/Sargates/.zshconfig/master/install/install.bash -O -)"

set -e



# echo "install.bash does not work yet"




command_exists() {
  command -v "$@" >/dev/null 2>&1
}

warning() {
	# TODO: fix this script with proper input handling. see omz `history -c` thread

	echo "This script will install a custom zsh terminal configuration."
	echo "This install script will install multiple different packages and tools."
	
}


	
install-deps() {

	local PACKAGES_TO_INSTALL=""

	#! Change this to iterate once to install packages, and a second time to create aliases, prevents repeated calls to `apt install` and is more streamlined
	while IFS=" " read -ra entry; do
		package="${entry[0]}"; command="${entry[1]}"; alias="${entry[2]}"

		[ -z "$package" ] && continue 			# ignore empty lines
		[[ "$package" = "//"* ]] && continue 	# ignore commented lines
		PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL $package"

	done < "$ZDOTDIR/install/packages.txt"

	echo "Installing packages: $PACKAGES_TO_INSTALL"
	# shellcheck disable=SC2086
	sudo apt install $PACKAGES_TO_INSTALL
	while IFS=" " read -ra entry; do
		package="${entry[0]}"; command="${entry[1]}"; alias="${entry[2]}"

		[ -z "$package" ] && continue 			# ignore empty lines
		[[ "$package" = "//"* ]] && continue 	# ignore commented lines
		[ "$package" == "$alias" ] && continue	# redundant alias, skip

		[ "$alias" != '_' ] && sudo ln -sf "$(which "$command")" "/usr/local/bin/$alias"
		# [ "$alias" != '_' ] && echo 'Alias is not "_", adding alias'

	done < "$ZDOTDIR/install/packages.txt"
}

main() {

	ZDOTDIR="$HOME/.zshconfig"

	#* ordering of commands
	# call `warning` to warn user of what this script will do
	# check if git is installed
	# git clone https://github.com/Sargates/.zshconfig.git $ZDOTDIR
	# cd $ZDOTDIR || exit 1
	# git submodule init && git submodule update
	# mv ${ZDOTDIR:-$HOME}/ohmyzsh/tools/install.sh ${ZDOTDIR:-$HOME}
	# rm -rf ${ZDOTDIR:-$HOME}/ohmyzsh
	# RUNZSH="no" ZDOTDIR="$ZDOTDIR" sh ${ZDOTDIR:-$HOME}/install.sh --keep-zshrc # install OMZ
	# rm ${ZDOTDIR:-$HOME}/install.sh

	command_exists git || {
		fmt_error "git is not installed"
		exit 1
	}

	warning
	sudo echo -n


	ZDOTDIR=$HOME/.zshconfig
	git clone https://github.com/Sargates/.zshconfig.git "$ZDOTDIR"
	cd "$ZDOTDIR" || exit 1
	git submodule init && git submodule update
	mv "${ZDOTDIR:-$HOME}/ohmyzsh/tools/install.sh" "${ZDOTDIR:-$HOME}"/omz-install.sh
	rm -rf "${ZDOTDIR:-$HOME}/ohmyzsh"
	# shellcheck disable=SC2098 disable=SC2097
	ZDOTDIR="$ZDOTDIR" sh "${ZDOTDIR:-$HOME}/omz-install.sh" --keep-zshrc --unattended
	rm "${ZDOTDIR:-$HOME}/omz-install.sh"


	# shellcheck disable=SC2098 disable=SC2097
	ZDOTDIR="$ZDOTDIR" zsh "$ZDOTDIR/scripts/symlinks.zsh" # Execute symlinks script

	install-deps

	# shellcheck disable=SC2016
	echo 'Config was successfully installed! Make sure to change your shell with `chsh -s /bin/zsh`'


}

main "$@"
