if [[ ! $ISWSL ]]; then
	echo "Should not load wsl.zsh on non-wsl instance"
	return
fi

autoload -Uz compinit
compinit

alias root='/mnt/c/'
alias desktop='~w/Desktop'
alias desk='desktop'
alias ds='desktop'
alias dl='~w/Downloads'
alias dev='/mnt/c/dev'
alias obs='~w/Desktop/Obsidian'

alias ld='~/Desktop'		# overrides GNU linker, I don't care
alias ldl='~/Downloads'
alias ldesktop='ld'
alias ldesk='ld'

alias cmd="cmd.exe"
alias cmdx="cmd /C"

open() {
	# Might still have issue when absolute path is passed, seems to work
	if [[ -e $1 ]]; then 				# check absolute path
		explorer.exe "`wslpath -w $1`"
		return 0
	elif [[ -e $PWD/$1 ]]; then 		# check relative path
		explorer.exe "`wslpath -w $PWD/$1`"
		return 0
	fi
	echo "No such file or directory: $1"
	return 1
}
alias psx="powershell.exe" # Syntax: `psx start .` (opens current dir)

mkdir -p ~/dev/CS-Stuff
builtin hash -d w=/mnt/c/Users/Nick
builtin hash -d cs=~/dev/CS-Stuff
builtin hash -d d=~w/Desktop
builtin hash -d dl=~w/Downloads

alias winpy='psx python'
alias winpython='winpy'

# commented out because fuck mono
# alias fixmono='sudo update-binfmts --disable cli' # required for Mono on WSL instance
alias gaming='python `cs-stuff Python/utils/gigachad.py`'
export LIBGL_ALWAYS_SOFTWARE=1 # This being unset causes a segmentation fault in some cases, `glxinfo, glxgears` See: https://github.com/microsoft/wslg/issues/715#issuecomment-1419138688 for full thread

# Execute dotnet program in powershell to leverage Windows
alias dnr="psx dotnet run"
alias dnb="psx dotnet build"

#! `--mouse` flag breaks Windows Terminal selection inside of pagers (git log, man, etc.). See: https://github.com/microsoft/terminal/issues/9165#issuecomment-1398208221
#! Holding shift down prevents this issue, but interaction still works the same (i.e. it will assume that you are selecting instead of deselecting because you are holding shift)
[[ "$LESS" != *--mouse* ]] && export LESS="$LESS --mouse" 					# Used for mouse functionality in less pagers (git log, man, etc.)
[[ "$LESS" != *--wheel-lines=* ]] && export LESS="$LESS --wheel-lines=2" 	# Change number of lines per scroll
# [[ "$LESS" != *-N* ]] 	&& export LESS="$LESS -N" 							# Show line numbers in less by default
#! disabled above because this messes with too many tools that use less

# export DISPLAY=192.168.176.1:0.0 # garbage for xserver
# export LIBGL_ALWAYS_INDIRECT=1


winpwd() {
	echo $(wslpath -m .)
}


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


#! Following commands use Windows Terminal, if you aren't using WT, remove the following
# This command creates a new Powershell tab inside the current window of WT with the CWD as starting directory
newps() {
	wt.exe -w 0 new-tab -d `winpwd` Powershell
}
alias newtab="wt.exe -w 0 nt -d ."
alias splittab="wt.exe -w 0 sp -d ."
# alias splitpane="wt.exe -w 0 sp -d ."
splitpane() {
	local args
	if [[ ! ${(C)1} =~ "(-V|-H)" ]]; then
		echo "Usage: splitpane [-H|-V|-h|-v]"
		return 1
	fi
	if [ $# -eq 1 ]; then
		wt.exe -w 0 sp ${(C)1} -d .
		return 0
	fi
	if [ $# -eq 0 ]; then
		wt.exe -w 0 sp -V -d .
		return 0
	fi

}
# Use `wt.exe --help` for more info, supports sub-help i.e. `wt.exe new-tab --help`

