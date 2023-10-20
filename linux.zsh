if [[ -a "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
	echo "Should not load linux.zsh on wsl instance"
	return
fi

autoload -Uz compinit
compinit


export ISWSL="0"
alias desktop='~/Desktop'
alias desk='desktop'
alias dl='~/Downloads'
alias dev='~/Desktop/Production'

mkdir -p ~/Desktop/Production
mkdir -p ~/Desktop/Production/CS_Stuff

hash -d cs=~/Desktop/Production/CS_Stuff

# cs_stuff() {
# 	BASEPATH="$csStuff"
# 	SUBPATH=$1
# 	if [ -d "$BASEPATH/$SUBPATH" ]; then
# 		$BASEPATH/$SUBPATH
# 		return 0
# 	fi
# 	echo $BASEPATH/$SUBPATH
# }
# compdef "_directories -/ -W $csStuff" cs_stuff
# alias cs-stuff='cs_stuff'
	


