
autoload -Uz compinit
compinit
if [[ -a "/etc/wsl.conf" ]]; then
	alias root='/mnt/c/'
	alias home='/mnt/c/Users/Nick'
	alias desktop='/mnt/c/Users/Nick/Desktop'
	alias dl='/mnt/c/Users/Nick/Downloads'
	alias dev='/mnt/c/Users/Nick/Desktop/Production'
	alias obs='/mnt/c/Users/Nick/Desktop/Obsidian'

	alias cmd="cmd.exe"
	alias cmdx="cmd /C"

	powershellOpen() {
		powershell.exe start `wslpath -w $1`
	}
	alias psx="powershell.exe"
	alias open="powershellOpen"

	# alias open="powershell.exe start '`wslpath -w $1`'"
	# alias start="powershell.exe `wslpath -w $1`"
	
	alias winpy='psx python'
	alias winpython='winpy'

	alias fixmono='sudo update-binfmts --disable cli' # required for Mono on WSL instance
	alias gaming='python `cs-stuff Python/+utils/gigachad.py`'
	alias dnr="psx dotnet run"
	alias dnb="psx dotnet build"

	cs_stuff() {
		BASEPATH="/mnt/c/Users/Nick/Desktop/Production/CS_Stuff"
		SUBPATH=$1
		if [ -d "$BASEPATH/$SUBPATH" ]; then
			$BASEPATH/$SUBPATH
			return 0
		fi
		echo $BASEPATH/$SUBPATH
	}
	compdef '_directories -/ -W /mnt/c/Users/Nick/Desktop/Production/CS_Stuff' cs_stuff
	alias cs-stuff='cs_stuff'


	# export DISPLAY=192.168.176.1:0.0 # garbage for xserver
	# export LIBGL_ALWAYS_INDIRECT=1
else
	alias home='~'
	alias desktop='~/Desktop'
	alias desk='desktop'
	alias dl='~/Downloads'
	alias dev='~/Desktop/Production'

	mkdir -p ~/Desktop/Production
	mkdir -p ~/Desktop/Production/CS_Stuff
	if [ ! -d "~/Desktop/Production" ]; then
	fi
	if [ ! -d "~/Desktop/Production/CS_Stuff" ]; then
	fi

	cs_stuff() {
		BASEPATH="~/Desktop/Production/CS_Stuff"
		SUBPATH=$1
		if [ -d "$BASEPATH/$SUBPATH" ]; then
			$BASEPATH/$SUBPATH
			return 0
		fi
		echo $BASEPATH/$SUBPATH
	}
	compdef '_directories -/ -W ~/Desktop/Production/CS_Stuff' cs_stuff
	alias cs-stuff='cs_stuff'



	# export DISPLAY=192.168.176.1:0.0 # garbage for xserver
	# export LIBGL_ALWAYS_INDIRECT=1
fi
