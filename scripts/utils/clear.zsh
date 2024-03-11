# This function just prevents clearing the terminal in tmux sessions (in case theres important command output)
clear() {
	if (( ${+TMUX} )); then
		/usr/bin/clear -x
	else
		/usr/bin/clear
	fi	
}