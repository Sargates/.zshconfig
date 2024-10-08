#!/bin/bash
# shellcheck disable=SC2006 disable=SC2098 disable=SC2097 disable=SC2034
#* Command to fetch and run install script
#* bash -c "$(curl -fsSL https://raw.githubusercontent.com/Sargates/.zshconfig/master/install/install.bash)"
#* bash -c "$(wget https://raw.githubusercontent.com/Sargates/.zshconfig/master/install/install.bash -O -)"

set -e


#! Helper functions taken from OMZ's install script
command_exists() {
	command -v "$@" >/dev/null 2>&1
}

if [ -t 1 ]; then
	is_tty() {
		true
	}
else
	is_tty() {
		false
	}
fi

supports_hyperlinks() {
	# $FORCE_HYPERLINK must be set and be non-zero (this acts as a logic bypass)
	if [ -n "$FORCE_HYPERLINK" ]; then
		[ "$FORCE_HYPERLINK" != 0 ]
		return $?
	fi

	# If stdout is not a tty, it doesn't support hyperlinks
	is_tty || return 1

	# DomTerm terminal emulator (domterm.org)
	if [ -n "$DOMTERM" ]; then
		return 0
	fi

	# VTE-based terminals above v0.50 (Gnome Terminal, Guake, ROXTerm, etc)
	if [ -n "$VTE_VERSION" ]; then
		[ $VTE_VERSION -ge 5000 ]
		return $?
	fi

	# If $TERM_PROGRAM is set, these terminals support hyperlinks
	case "$TERM_PROGRAM" in
	Hyper|iTerm.app|terminology|WezTerm|vscode) return 0 ;;
	esac

	# These termcap entries support hyperlinks
	case "$TERM" in
	xterm-kitty|alacritty|alacritty-direct) return 0 ;;
	esac

	# xfce4-terminal supports hyperlinks
	if [ "$COLORTERM" = "xfce4-terminal" ]; then
		return 0
	fi

	# Windows Terminal also supports hyperlinks
	if [ -n "$WT_SESSION" ]; then
		return 0
	fi

	# Konsole supports hyperlinks, but it's an opt-in setting that can't be detected
	# https://github.com/ohmyzsh/ohmyzsh/issues/10964
	# if [ -n "$KONSOLE_VERSION" ]; then
	#	 return 0
	# fi

	return 1
}

# Adapted from code and information by Anton Kochkov (@XVilka)
# Source: https://gist.github.com/XVilka/8346728
supports_truecolor() {
	case "$COLORTERM" in
	truecolor|24bit) return 0 ;;
	esac

	case "$TERM" in
	iterm           |\
	tmux-truecolor  |\
	linux-truecolor |\
	xterm-truecolor |\
	screen-truecolor) return 0 ;;
	esac

	return 1
}

fmt_link() {
	# $1: text, $2: url, $3: fallback mode
	if supports_hyperlinks; then
		printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$2" "$1"
		return
	fi

	case "$3" in
	--text) printf '%s\n' "$1" ;;
	--url|*) fmt_underline "$2" ;;
	esac
}

fmt_underline() {
	is_tty && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

# shellcheck disable=SC2016 # backtick in single-quote
fmt_code() {
	is_tty && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

fmt_error() {
	printf '%sError: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "$FMT_RESET" >&2
}

fmt_warning() {
	printf '%sWarning: %s%s\n' "${FMT_BOLD}${FMT_YELLOW}" "$*" "$FMT_RESET" >&2
}

fmt_success() {
	printf '%s%s%s\n' "${FMT_BOLD}${FMT_GREEN}" "$*" "$FMT_RESET" >&2
}

setup_color() {
	# Only use colors if connected to a terminal
	if ! is_tty; then
		FMT_RED=""
		FMT_GREEN=""
		FMT_YELLOW=""
		FMT_BLUE=""
		FMT_BOLD=""
		FMT_RESET=""
		return
	fi

	FMT_RED=$(printf '\033[31m')
	FMT_GREEN=$(printf '\033[32m')
	FMT_YELLOW=$(printf '\033[33m')
	FMT_BLUE=$(printf '\033[34m')
	FMT_BOLD=$(printf '\033[1m')
	FMT_RESET=$(printf '\033[0m')
}


warning() {
	# TODO: fix this script with proper input handling. see omz `history -c` thread

	echo "This script will install a custom zsh terminal configuration."
	echo "This install script will install multiple different packages and tools."
	
}



install-deps() {

	local PACKAGES_TO_INSTALL="" failed="no"
	local version="$(lsb_release -a 2>/dev/null | grep Release | awk '{ print $2 }')"

	#! Change this to iterate once to install packages, and a second time to create aliases, prevents repeated calls to `apt install` and is more streamlined
	while IFS=" " read -ra entry; do
		package="${entry[0]}"; command="${entry[1]}"; alias="${entry[2]}"; min_version="${entry[3]}"


		[ -z "$package" ] && continue 			# ignore empty lines
		[[ "$package" = "//"* ]] && continue 	# ignore commented lines

		# If there is a minumum required ubuntu version and the current version is below the minimum version, continue
		{ [ ! $min_version = "_" ] && [ $version -lt $min_version  ]; } && continue


		PACKAGES_TO_INSTALL="$package $PACKAGES_TO_INSTALL"

	done < "$ZDOTDIR/install/packages.txt"

	echo "Installing packages: $PACKAGES_TO_INSTALL"
	# shellcheck disable=SC2086
	sudo apt install $PACKAGES_TO_INSTALL -y || failed="yes"
	if [ $failed == "no" ]; then
		while IFS=" " read -ra entry; do
			package="${entry[0]}"; command="${entry[1]}"; alias="${entry[2]}"; min_version="${entry[3]}"

			[ -z "$package" ] && continue 			# ignore empty lines
			[[ "$package" = "//"* ]] && continue 	# ignore commented lines
			[ "$package" == "$alias" ] && continue	# redundant alias, skip

			[ "$alias" != '_' ] && sudo ln -sf "$(which "$command")" "/usr/local/bin/$alias"
			# [ "$alias" != '_' ] && echo 'Alias is not "_", adding alias'

		done < "$ZDOTDIR/install/packages.txt"
	fi
	
}

main() {
	setup_color

	local PRELIMINARY_PACKAGES=()
	command_exists git || PRELIMINARY_PACKAGES+=("git")
	command_exists zsh || PRELIMINARY_PACKAGES+=("zsh")

	if (( ${#PRELIMINARY_PACKAGES[@]} )); then
		fmt_warning "The package(s): ${PRELIMINARY_PACKAGES[*]}, need to be installed."
		sudo apt install $PRELIMINARY_PACKAGES
	fi



	warning
	sudo echo -n

	ZDOTDIR="$HOME/.zshconfig"
	if [ ! -d "$ZDOTDIR" ]; then
		git clone https://github.com/Sargates/.zshconfig.git "$ZDOTDIR"
		cd "$ZDOTDIR" || exit 1
		git submodule init && git submodule update
		mv "${ZDOTDIR:-$HOME}/ohmyzsh/tools/install.sh" "${ZDOTDIR:-$HOME}"/omz-install.sh
		rm -rf "${ZDOTDIR:-$HOME}/ohmyzsh"
		# shellcheck disable=SC2098 disable=SC2097
		ZDOTDIR="$ZDOTDIR" sh "${ZDOTDIR:-$HOME}/omz-install.sh" --keep-zshrc --unattended
		rm "${ZDOTDIR:-$HOME}/omz-install.sh"

		# ZDOTDIR="$ZDOTDIR" zsh "$ZDOTDIR/scripts/config.zsh"			# Doesnt even work to execute config like this because the env is separate
		ZDOTDIR="$ZDOTDIR" zsh "$ZDOTDIR/scripts/symlinks.zsh" --force 	# Execute symlinks script
	else
		fmt_warning "$ZDOTDIR already exists. Delete it or run \`git -C $ZDOTDIR pull\` if it's out of date."
	fi


	if command_exists apt; then
		install-deps
	else
		package_location="$ZDOTDIR/install/packages.txt" # Save path/to/packages.txt to variable
		link_to_package=$package_location
		if [ -a "/proc/sys/fs/binfmt_misc/WSLInterop" ]; then 
			# If on WSL, use `wslpath` to format windows path to file, `//wsl.localhost/Ubuntu/path/to/file`
			link_to_package=`wslpath -m "$package_location"`
		fi
		fmt_warning "Apt is not installed. ${FMT_RED}Unable to install packages automatically."
		fmt_warning "See `fmt_link "$package_location" "file://$link_to_package" --text` for the list of packages that couldn't be installed."

	fi
	fmt_success "Config was successfully installed! Make sure to change your shell with \`chsh -s /bin/zsh\`."
}

main "$@"
