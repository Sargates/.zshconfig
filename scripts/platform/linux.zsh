if (( $ISWSL )); then
	echo "Should not load linux.zsh on wsl instance"
	return
fi


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


