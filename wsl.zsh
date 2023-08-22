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
	alias psx="powershell.exe"

	powershellOpen() {
		
		psx start `wslpath -w $1`
	}
	alias open="powershellOpen"

	# alias open="powershell.exe start '`wslpath -w $1`'"
	# alias start="powershell.exe `wslpath -w $1`"
	
	alias winpy='psx python'
	alias winpython='winpy'

	alias fixmono='sudo update-binfmts --disable cli' # required for Mono on WSL instance
	alias gaming='python $(cs-stuff Python/+utils/gigachad.py)'
	alias dnr="psx dotnet run"
	alias dnb="psx dotnet build"

	cs_stuff() {
		cd /mnt/c/Users/Nick/Desktop/Production/CS_Stuff/$1
	}
	compdef '_directories -/ -W /mnt/c/Users/Nick/Desktop/Production/CS_Stuff' cs_stuff
	alias cs-stuff='cs_stuff'


	# export DISPLAY=192.168.176.1:0.0 # garbage for xserver
	# export LIBGL_ALWAYS_INDIRECT=1
fi
