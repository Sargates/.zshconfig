if [[ -a "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
	echo "Should not load linux.zsh on wsl instance"
	return
fi

autoload -Uz compinit
compinit


alias desktop='~/Desktop'
alias desk='desktop'
alias dl='~/Downloads'
alias dev='~/dev'

mkdir -p ~/dev/CS-Stuff

builtin hash -d cs=~/dev/CS-Stuff


function cs-stuff() { # function seems required here or terminal yells at you
	BASEPATH=~cs
	SUBPATH=$1
	if [ -d "$BASEPATH/$SUBPATH" ]; then
		cd $BASEPATH/$SUBPATH
		return 0
	fi
	if [ -e "$BASEPATH/$SUBPATH" ]; then
		echo $BASEPATH/$SUBPATH
		return 0
	fi
	echo "Could not find file \"~cs/$SUBPATH\""
	return 1
}
compdef "_directories -/ -W ~cs" cs-stuff