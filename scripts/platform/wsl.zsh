if (( ! $ISWSL )); then
	echo "Should not load wsl.zsh on non-wsl instance"
	return
fi

builtin hash -d w=/mnt/c/Users/$USER 								# Hash for Windows user directory
alias desktop='~w/Desktop'; 	alias desk='desktop'				# Desktop Aliases
alias ds='desktop'; 			builtin hash -d d=~w/Desktop		# Hash for Windows Desktop
alias dl='~w/Downloads';		builtin hash -d dl=~w/Downloads		# Hash for Windows Downloads
# alias obs='~w/Desktop/Obsidian'

alias ld='~/Desktop'		# overrides GNU linker, I don't care
alias ldl='~/Downloads'


if (( ${+ZSH_CONFIG[create_cs]} )); then
	mkdir -p ~/dev/CS-Stuff
	builtin hash -d cs=~/dev/CS-Stuff
	alias dev='~/dev'
fi

#* Just use `python.exe`, should be identical
# alias winpy='psx python'
# alias winpython='winpy'


# open() {
# 	# Check if url is valid. could use curl to do this, seems wasteful
# 	content=$(curl --head --silent -gk "$*" | head -n 1)
# 	if [ -n "$content" ]; then
# 		powershell.exe Start-Process $1
# 		return 0
# 	fi


# 	#? Potential change: Use the `:A` expansion selector. evaluates relative path traversals 
# 	#? like `.` and `..` and expands them to an absolute path. Use this instead of the double check
# 	# Might still have issue when absolute path is passed, seems to work
# 	if [[ -e ${1:A} ]]; then 				# check absolute path
# 		explorer.exe "`wslpath -w ${1:A}`"
# 		return 0
# 	fi
# 	echo "No such file or directory: $1"
# 	return 1
# }
alias open="wslview" # Apparently this has always existed
alias psx="powershell.exe" # Syntax: `psx start .` (opens current dir)
alias cmd="cmd.exe"
alias cmdx="cmd /C"

# commented out because fuck mono
# alias fixmono='sudo update-binfmts --disable cli' # required for Mono on WSL instance
alias gaming='python ~cs/Python/utils/gigachad.py'
export LIBGL_ALWAYS_SOFTWARE=1 # This being unset causes a segmentation fault in some cases, `glxinfo, glxgears` See: https://github.com/microsoft/wslg/issues/715#issuecomment-1419138688 for full thread

# Execute dotnet program in powershell to leverage Windows
alias dnr="dotnet.exe run"
alias dnb="dotnet.exe build"



ffmpeg-compress() { # Custom function to compress a video to a specified bitrate. Uses NVenc to leverage GPU, requires an nvidia GPU. Only using in WSL for now
	# See https://www.reddit.com/r/zsh/comments/s09vot/comment/hs1ixmx/
	
	emulate -L zsh
	zmodload zsh/zutil || return

	# Default option values can be specified as (value).
	local help bitrate input output=(default)

	# Brace expansions are great for specifying short and long
	# option names without duplicating any information.
	zparseopts -D -F -K -- \
		{h,-help}=help       \
		{b,-bitrate}:=bitrate \
		{i,-input}:=input \
		{o,-output}:=output || return
	# zparseopts prints an error message if it cannot parse
	# arguments, so we can simply return on error.

	if (( $#help )); then
		print -rC1 --      \
		"$0 [-h|--help]" \
		"$0 [-b|--bitrate] [-f|--input=<file>] [<message...>]"
		return
	fi

	# Presence of options can be checked via (( $#option )).
	if (( ! $#input )); then
		echo "Error: Input file not given"
		return 1
	fi
	if [[ ! -f "${input[-1]:A}" ]]; then
		echo "Error: Input file does not exist"
		return 1
	fi
	if (( ! $#output )); then
		echo "Error: Output file not given"
		return 1
	fi
	if (( ! $#bitrate )); then
		echo "Error: Bitrate not given"
		return 1
	fi

	ffmpeg -hwaccel cuda -extra_hw_frames 2 -i "${input[-1]:A}" -c:v h264_nvenc -b:v "${bitrate[-1]}" -c:a copy "${output[-1]:A}"
}



# export DISPLAY=192.168.176.1:0.0 # garbage for xserver
# export LIBGL_ALWAYS_INDIRECT=1


winpwd() {
	echo $(wslpath -m .)
}


# This MinGW cmake toolchain file can be found here: https://github.com/glfw/glfw/blob/master/CMake/x86_64-w64-mingw32.cmake
function wincmake() {
	if [ ! -e ~/dev/mingw-toolchain.cmake ]; then
		echo "MinGW CMake Toolchain file does not exist."
		echo "Get one from https://github.com/glfw/glfw/blob/master/CMake/x86_64-w64-mingw32.cmake"
		echo "and put it in the ~/dev directory"
		return 1
	fi
	cmake $@ -DCMAKE_TOOLCHAIN_FILE=$HOME/dev/mingw-toolchain.cmake
}
alias mingwcmake='wincmake'


#* Seems to work now without these flags? I can't remember how it behaved before, so idk
# // #! `--mouse` flag breaks Windows Terminal selection inside of pagers (git log, man, etc.). See: https://github.com/microsoft/terminal/issues/9165#issuecomment-1398208221
# // #! Holding shift down prevents this issue, but interaction still works the same (i.e. it will assume that you are selecting instead of deselecting because you are holding shift)
# // # [[ "$LESS" != *--mouse* ]] && export LESS="$LESS --mouse" 					# Used for mouse functionality in less pagers (git log, man, etc.)
# // # [[ "$LESS" != *--wheel-lines=* ]] && export LESS="$LESS --wheel-lines=2" 	# Change number of lines per scroll
# // # [[ "$LESS" != *-N* ]] 	&& export LESS="$LESS -N" 							# Show line numbers in less by default
# // #! disabled above because this messes with too many tools that use less

#! Following commands use Windows Terminal, if you aren't using WT, remove/ignore the following
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

