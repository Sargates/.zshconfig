# Improves clipcopy to write 
clear() {
	if (( ${+TMUX} )); then # prevents clearing tmux sessions 
		/usr/bin/clear -x
	else
		/usr/bin/clear
	fi	
}