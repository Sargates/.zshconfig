# Allows you to open firefox from the terminal and redirects the debug output
firefox() {
	if [[ ${+commands[firefox]} ]]; then
		command firefox >/dev/null 2>&1 &	# Background and silence debug output
		return
	fi
	command firefox 						# If firefox is not a recognized command, run command to receive standard error message
}
