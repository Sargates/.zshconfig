#!/bin/zsh

#! This script should be loaded automatically by OMZ because it is stored in $ZSHCUSTOM. In this script, hand

# setopt extended_glob
setopt globdots

export ZSHCFG="$HOME/.zshconfig"


#! Set aliases
alias pip='python -m pip'
alias zshrc='source ~/.zshrc'
alias cdzsh='cd ~/.zshconfig'

# alias listapt="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
alias haconnect='ssh hassio@homeassistant.local' 				# Connect to local home assisstant server (if exists)
alias listapt='apt list --installed'							# List installed apt packages (optionally use with grep)
alias listjava='apt search openjdk-.+-'							# Search installable JDK's because I can never remember the title format

#* Set configuration
local baseLS="ls -lah --color=always"							# Preserves coloring when piping to grep with --color=never flag i.e. `l | grep --color=never {PATTERN}`
alias l="$baseLS --group-directories-first"						# Primary "ls" command, groups dirs first, top->bottom: .dirs, dirs, .files, files
export LANG="C.UTF-8"											# Change LANG (mainly for sort order when calling ls -l)
export EDITOR="code"											# Use VSCode as primary EDITOR
alias nano="/usr/bin/nano --nonewlines"							# Override nano command with passed argument `--nonewline` to prevent dumb newline at EOF

alias zshcfg="$EDITOR ~/.zshconfig"								# Open zsh config in editor
alias mcd='() { md $1 && cd $_ }'								# Used to create and cd to a new directory in one command
alias killssh='kill `pgrep ssh-agent`'							# Used to reset ssh-agent
alias clip='perl -pe "s/^((?:(?>(?:\e\[.*?m)*).){`tput cols`}).*/$1\e[m/"'								# Use with pipe to clip output to terminal size to prevent line wrapping
alias clgrep="clip|grep"										# Use with pipe to have clipped grep output. Buggy; Doesn't match patterns to what was clipped
alias ncgrep="grep --color=never"								# Grep with no color
alias listports="sudo lsof -i -P -n | grep LISTEN"				# Used to list open ports -- useful for being paranoid :)
alias repromptssh="source $ZSHCFG/scripts/utils/ssh.zsh"		# Re-source `ssh.zsh` to reprompt the adding of keys

alias mv="command mv -n"										# Prevent file overwriting, this shit happens too often

alias lrt="$baseLS -t -r"										# Used to list items in directory and sort by time-last-modified. `-r` causes most recent file to be at bottom of output
alias ltr="lrt"													# autocorrect for lrt

alias gr='git -C `git root`'									# OMZ defines `gr` as `git remote`. Here, `gr` is short for `git root` which will execute the following command in the git project's root dir, i.e. `gr add --all`, will add all files without needing to cd to root or do path traversal


alias trim="sed 's/^[ \t]*//;s/[ \t]*$//'"						# Trim leading and trailing whitespace


ZSH_COMPDUMP="$HOME/.zcompdump_archive/.zcompdump-WSL00-NG-5.8.1"

aptsearch() {
	local PACKAGE_SERVER="jammy" # 22.04 -> jammy; 24.04 -> noble
	local PREFIX=""
	if [[ ${+commands[unbuffer]} -ne 0 ]]; then
		PREFIX="unbuffer"
	fi

	# local SEPARATOR=$'\033[F' # control char to move up a line, fixes double newline between grep matches
	#! This value doesn't work currently. awk will break if `-A1 --group-separator=$SEPARATOR` is passed because output of grep will be weird
	# local GREP_ARGS='--color=none -A1 --group-separator=$SEPARATOR'

	local GREP_ARGS='--color=none'
	
	# // This command pipes output twice to grep, first to include lines only with the package server (to only include package names), second is to narrow down packages that include first arg verbatim
	# // First one includes $GREP_ARGS to prevent highlighting of 
	# // local OUTPUT="$($PREFIX apt search $@ | grep "$PACKAGE_SERVER" $GREP_ARGS | GREP_COLORS="ms=41" grep $1 --color=always)"
	local OUTPUT="$($PREFIX apt search $@ | grep "$PACKAGE_SERVER" $GREP_ARGS | grep $1 $GREP_ARGS)"


	# regex pattern for matching semantic versioning, official semver maintainers give a better matching pattern but I could get it to work, see https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
	#! Pattern needs double escape here
	local PATTERN='[0-9]*\\.[0-9]*\\.[0-9]*'

	
	echo $OUTPUT | awk -F'[ /]' -v PATTERN="$PATTERN" -e '$3 ~ PATTERN {match($3, PATTERN); print $1"@"substr($3, RSTART, RLENGTH)"/"$2" "$5 }'
	
	[ ! $PREFIX ] && echo 'This command uses unbuffer by default, install it using `apt install expect` or modify $ZSHCFG/profile.zsh to remove this notification'
}

#! Doesn't work if using `sudo apt` for obvious reasons
apt() { # https://unix.stackexchange.com/a/670978
    if [ "$1" = "search" ]; then
        shift # eat the "shift" argument
		echo $#
		if [ $# -eq 0 ]; then
			command apt search
			return $?
		fi
        aptsearch "$@"
    else 
        command apt "$@"
    fi
}



# Recursive Sourcing
for f in $HOME/.zshconfig/scripts/**/*.zsh(D); do # Recursively source all `.zsh` files inside the `scripts` folder
	if [ -d $f ]; then continue; fi
	# if [[ ${f:h:t} == "utils" ]] && [[ ! ${f:t} == "utils.zsh" ]]; then continue; fi #! testing command
	file=$f:t
	ext=$f:t:e


	if [[ $ext == "zsh" ]]; then
		if [[ $file == "update.zsh" ]]; then continue; fi 					# Ignore sourcing `update.zsh`
		if [[ $file == "linux.zsh" && $ISWSL ]]; then continue; fi	# Avoid sourcing `linux.zsh` on WSL
		if [[ $file == "wsl.zsh" && ! $ISWSL ]]; then continue; fi		# Avoid sourcing `wsl.zsh` on Linux
		source "$f"
	fi;
done

# Syntax highlighting
source "$ZSHCFG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


