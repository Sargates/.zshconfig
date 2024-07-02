if (( $ISWSL )); then
	echo "Should not load linux.zsh on wsl instance"
	return
fi

autoload -Uz compinit
compinit


alias desktop='~/Desktop'
alias ds='desktop'
builtin hash -d d=~/Desktop

alias dl='~/Downloads'
builtin hash -d dl=~/Downloads

if (( ${+ZSH_CONFIG[create_cs]} )); then
	mkdir -p ~/dev/CS-Stuff
	builtin hash -d cs=~/dev/CS-Stuff
	alias dev='~/dev'
fi




#? I dont use this anymore, here just to look at
# function cs-stuff() { # "function" keyword seems required here or terminal yells at you
# 	BASEPATH=~cs
# 	SUBPATH=$1
# 	if [ -d "$BASEPATH/$SUBPATH" ]; then
# 		cd $BASEPATH/$SUBPATH
# 		return 0
# 	fi
# 	if [ -e "$BASEPATH/$SUBPATH" ]; then
# 		echo $BASEPATH/$SUBPATH
# 		return 0
# 	fi
# 	echo "Could not find file \"~cs/$SUBPATH\""
# 	return 1
# }
# compdef "_directories -/ -W ~cs" cs-stuff