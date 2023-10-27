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

PowershellOpen() {
	explorer.exe "`wslpath -w $PWD/$1`"
}
alias psx="powershell.exe"
alias open="PowershellOpen"

hash -d w=/mnt/c/Users/Nick
hash -d cs=/mnt/c/Users/Nick/Desktop/Production/CS_Stuff

# alias open="powershell.exe start '`wslpath -w "$PWD/$1"`'"
# alias start="powershell.exe `wslpath -w $1`"

alias winpy='psx python'
alias winpython='winpy'

alias fixmono='sudo update-binfmts --disable cli' # required for Mono on WSL instance
alias gaming='python `cs-stuff Python/+utils/gigachad.py`'
alias dnr="psx dotnet run"
alias dnb="psx dotnet build"


# export DISPLAY=192.168.176.1:0.0 # garbage for xserver
# export LIBGL_ALWAYS_INDIRECT=1


csStuff=`echo ~cs`
cs_stuff() {
	BASEPATH=$csStuff
	SUBPATH=$1
	if [ -d "$BASEPATH/$SUBPATH" ]; then
		$BASEPATH/$SUBPATH
		return 0
	fi
	echo $BASEPATH/$SUBPATH
}
compdef "_directories -/ -W $csStuff" cs_stuff
alias cs-stuff='cs_stuff'