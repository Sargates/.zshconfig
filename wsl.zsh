if [[ ! -a "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
	echo "Should not load wsl.zsh on non-wsl instance"
	return
fi

autoload -Uz compinit
compinit

alias root='/mnt/c/'
alias desktop='/mnt/c/Users/Nick/Desktop'
alias desk='desktop'
alias dl='/mnt/c/Users/Nick/Downloads'
alias dev='/mnt/c/Users/Nick/Desktop/Production'
alias obs='/mnt/c/Users/Nick/Desktop/Obsidian'

alias ld='~/Desktop'
alias ldl='~/Downloads'
alias ldesktop='ld'
alias ldesk='ld'

alias cmd="cmd.exe"
alias cmdx="cmd /C"

open() {
	# Might still have issue when absolute path is passed, seems to work
	if [[ -d $1 ]]; then
		explorer.exe "`wslpath -w $1`"
		return 0
	elif [[ -d $PWD/$1 ]]; then
		explorer.exe "`wslpath -w $PWD/$1`"
		return 0
	fi
	echo "No such file or directory: $1"
	return 1
}
alias psx="powershell.exe" # Syntax: `psx start .` (opens current dir)

builtin hash -d w=/mnt/c/Users/Nick
builtin hash -d cs=/mnt/c/Users/Nick/Desktop/Production/CS_Stuff

alias winpy='psx python'
alias winpython='winpy'

alias fixmono='sudo update-binfmts --disable cli' # required for Mono on WSL instance
alias gaming='python `cs-stuff Python/utils/gigachad.py`'
alias dnr="psx dotnet run"
export LIBGL_ALWAYS_SOFTWARE=1 # This being unset causes a segmentation fault in some cases, `glxinfo, glxgears` See: https://github.com/microsoft/wslg/issues/715#issuecomment-1419138688 for full thread
alias dnb="psx dotnet build"

[[ "$LESS" != *--mouse* ]] && export LESS="$LESS --mouse" # Used for mouse functionality in less pagers (git log, man, etc.)
#! Above line breaks Windows Terminal selection inside of pagers (git log, man, etc.). See: https://github.com/microsoft/terminal/issues/9165#issuecomment-1398208221
#! Holding shift down prevents this issue, but interaction still works the same (i.e. holding shift and clicking around with assume that you are selecting instead of deselecting)
[[ "$LESS" != *--wheel-lines=* ]] && export LESS="$LESS --wheel-lines=2" # Change number of lines per scroll


# export DISPLAY=192.168.176.1:0.0 # garbage for xserver
# export LIBGL_ALWAYS_INDIRECT=1


winpwd() {
	echo $(wslpath -m .)
}


csStuff=`echo ~cs`
cs_stuff() {
	BASEPATH=$csStuff
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
compdef "_directories -/ -W $csStuff" cs_stuff
alias cs-stuff='cs_stuff'