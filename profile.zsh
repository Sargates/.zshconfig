#!/bin/zsh

#! This script should be loaded automatically by OMZ because it is stored in $ZSHCUSTOM. In this script, handle all things relating to customization of the config; aliases, command defaults, etc

setopt globdots

export ZSHCFG="$HOME/.zshconfig"


#! Set aliases
alias pip='python3 -m pip'
alias zshrc='source ~/.zshrc'
alias cdzsh='cd $ZDOTDIR'


#* Set configuration
local baseLS="ls -lah --color=always"											# Preserves coloring when piping to grep with --color=never flag i.e. `l | grep --color=never {PATTERN}`
alias l="$baseLS --group-directories-first"										# Primary "ls" command, groups dirs first, top->bottom: .dirs, dirs, .files, files
export LANG="C.UTF-8"															# Change LANG (mainly for sort order when calling ls -l)
(( ${+commands[code]} )) && EDITOR="code"											# Use VSCode as primary EDITOR
alias nano="/usr/bin/nano --nonewlines"											# Override nano command with passed argument `--nonewline` to prevent dumb newline at EOF

alias zshcfg="$EDITOR ~/.zshconfig"												# Open zsh config in editor
alias mcd='() { md $1 && cd $_ }'												# Used to create and cd to a new directory in one command
alias killssh='kill `pgrep ssh-agent`'											# Used to reset ssh-agent
alias clip='perl -pe "s/^((?:(?>(?:\e\[.*?m)*).){`tput cols`}).*/$1\e[m/"'		# Use with pipe to clip output to terminal size to prevent line wrapping
alias clgrep="clip|grep"														# Use with pipe to have clipped grep output. Buggy; Doesn't match patterns to what was clipped
alias ncgrep="grep --color=never"												# Grep with no color
alias listports="sudo lsof -i -P -n | grep LISTEN"								# Used to list open ports -- useful for being paranoid :)
alias repromptssh="source $ZDOTDIR/scripts/utils/ssh.zsh"						# Re-source `ssh.zsh` to reprompt the adding of keys

#* This is meant to be a replacement for `rm` to prevent removing sensitive directories, but this doesn't prompt for confirmation from zsh's `rm_star` option
#* Aliasing like this, does not work. I haven't tried directly replacing the `rm` binary by renaming `safe-rm` to `rm` in `/usr/bin`, that may work because I doubt ZSH's option is embedded into the binary itself, likely just checks the command against all aliases
# // [ ${+commands[safe-rm]} -ne 0 ] && alias rm="safe-rm --preserve-root"

alias parseetcpasswd='awk -F: "\$3 >= 1000" /etc/passwd | sort -t: -nk3 | column -t -s: -N "USER,PASSWORD,UID,GID,COMMENT,HOME DIR,LOGIN SHELL"'
alias parseetcgroup='awk -F: "\$3 >= 1000" /etc/group | sort -t: -nk3 | column -t -s: -N "GROUP,PASSWORD,GID,USERS"'

alias mv="command mv -n"														# Prevent file overwriting, this shit happens too often

alias lrt="$baseLS -t -r"														# Used to list items in directory and sort by time-last-modified. `-r` causes most recent file to be at bottom of output
alias ltr="lrt"																	# autocorrect for lrt

alias gr='git -C `git root`'													# OMZ defines `gr` as `git remote`. Here, `gr` is short for `git root` which will execute the following command in the git project's root dir, i.e. `gr add --all`, will add all files without needing to cd to root or do path traversal


alias trim="sed 's/^[ \t]*//;s/[ \t]*$//'"										# Trim leading and trailing whitespace


aptsearch() { #! If you're having issues with output, it's likely that the version of the package is not a valid semantic version.
	# Get package server codename programatically, 22.04 -> jammy; 24.04 -> noble
	local ID=$(grep '^ID=' /etc/os-release | cut -d= -f2)
	local PACKAGE_SERVER
	if [ $ID = 'ubuntu' ]; then
		PACKAGE_SERVER="$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2)"
	elif [ $ID = 'debian' ]; then
		PACKAGE_SERVER='stable'
	else
		/usr/bin/apt search $1
		printf '\e[31mCould not determine consisted package release; OS not fully supported for `apt search` alias.
Ran command: `/usr/bin/apt search %s`\e[m' $1
		return 0
	fi


	[ ${+commands[unbuffer]} -ne 0 ] && local PREFIX="unbuffer"

	#! This value doesn't work currently. awk will break if `-A1 --group-separator=$SEPARATOR` is passed because output of grep will be weird
	# // local SEPARATOR=$'\033[F' # control char to move up a line, fixes double newline between grep matches
	# // local GREP_ARGS='--color=none -A1 --group-separator=$SEPARATOR'

	[ ! $GREP_COLORS ] && local GREP_COLORS="48;5;239" # define $GREP_COLORS if its not defined already, (used for testing different colors without having to re-source .zshrc)

	local OUTPUT=$(
		$PREFIX /usr/bin/apt search $@ | 										# Search for package
		grep -v -e "^  " -e "^$" | 												# Remove description and spacing lines from `apt` output
		tail -n +3 | 															# Remove info from output
		GREP_COLORS="ms=$GREP_COLORS" grep  --color=always -e "^" -e "$1" | 	# Highlight matches for $1 in $GREP_COLORS
		sed -e $'s/\033[[]m/\033[40m/' 											# Fix ANSI color codes; Replace the first color reset (from previous `grep`) with background reset (because $GREP_COLORS changes background color)
	)


	# regex pattern for matching semantic versioning, official semver maintainers give a better matching pattern but I could get it to work, see https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
	#! Pattern needs double escape here
	# local PATTERN='[0-9]*\\.[0-9]*'

	# echo $OUTPUT | awk -F'[ /]' -v PATTERN="$PATTERN" '$3 ~ PATTERN {match($3, PATTERN); print $1"@"substr($3, RSTART, RLENGTH)"/"$2" "$5 }' #? Used for semantic versioning
	echo $OUTPUT | awk -F'[ /]' '{ print $1"@"$3"/"$2" "$5 }'
	
	[ ! $PREFIX ] && printf $'\e[33;4mThis command uses unbuffer to add coloring to this output. Install it using `apt install expect` or modify %s/profile.zsh to remove this notification\e[0m\n' $ZDOTDIR
	return 0
}

#! Doesn't work if using `sudo apt` for obvious reasons
apt() { # https://unix.stackexchange.com/a/670978
	if [ "$1" = "search" ]; then
		shift # eat the "shift" argument
		# echo $#
		if [ $# -eq 0 ]; then
			command apt search
			return $?
		fi
		aptsearch "$@"
		return $?
	fi
	command apt "$@"
}


source_scripts() {
	# Recursive Sourcing
	local scripts=( $ZDOTDIR/scripts/**/*.zsh )
	source $ZDOTDIR/scripts/config.zsh # Source `config.zsh` before every other script as a dependency
	for file in $scripts; do
		if [[ ${file:t} == "config.zsh" ]]; then continue; fi					# source `config.zsh` manually

		if [[ ${file:t} == "update.zsh" ]]; then continue; fi 					# Ignore sourcing `update.zsh`, for now
		if [[ ${file:t} == "linux.zsh" ]] && (( $ISWSL )); then continue; fi	# Avoid sourcing `linux.zsh` on WSL
		if [[ ${file:t} == "wsl.zsh" ]] && (( ! $ISWSL )); then continue; fi	# Avoid sourcing `wsl.zsh` on Linux

		# echo ${file}
		source "$file"
	done
}

source_scripts

# Syntax highlighting
source "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

detect-clipboard # Call this now to prevent lag from figuring out how to define `clipcopy` and `clippaste` on the fly
