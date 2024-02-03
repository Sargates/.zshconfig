# Copy a string or a file's contents to clipboard. Supports piping
alias copy="clipcopy" # clipcopy is defined by OMZ, trying this out

#! This is WIP -- stuff i got elsewhere/stuff im not confident in
# copy() {
# 	local inp output blacklist hasStdInput containsBlacklist

# 	# Checks if stdin is empty
# 	hasStdInput=0
# 	read -t 0
# 	if [ $? -ne 0 ] && [ $@ -eq "" ]; then hasStdInput=1; fi
# 	echo $hasStdInput

# 	# Blacklisted inputs because they break things
# 	blacklist=(sudo rm gaming) # Any of these will be ignored



# 	inp=$@
# 	[ $hasStdInput -ne 0 ] && inp=$(cat /dev/stdin)
	
# 	containsBlacklist=0
# 	for word in $blacklist; do
# 		if [ $containsBlacklist -ne 0 ]; then break; fi
# 		contains "$inp" "$word"
# 		if [ $? -ne 0 ]; then
# 			containsBlacklist=1
# 		fi
# 	done

# 	if [ ! $inp ] || [ $containsBlacklist -ne 0 ]; then # if inp is empty or inp contains blacklist
# 		echo "No input supplied; Nothing to copy"
# 		return
# 	fi

# 	# Default parameter expansion: 
# 	# See docs: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion
# 	# @ Represents every parameter passed in a concatenated string
# 	# :- represents setting a default value and
# 	# /dev/stdin is a file representing the input passed to the terminal
# 	# Wrapping the variable inside ${___} is the syntax for specifying things like default parameter value or other sub 
# 	# If $@ is an empty string, it will be assigned to whatever was passed from `/dev/stdin`
	
	


# 	# This is evil because of eval.
# 	eval "$inp 2>&1 >/dev/null" 2>&1 >/dev/null # requires double redirect in case eval fails too
	
# 	if [ $? -ne 0 ]; then # If command failed, just copy $inp to clipboard instead
# 		echo "$inp" | clipcopy
# 		echo "Output $inp to clipboard"
# 		return
# 	fi

# 	output=$(eval $inp)
# 	echo $output | clipcopy
# 	echo "Output $output to clipboard"
# }
# copy() {
# 	local inp
# 	if [[ $# -eq 1 ]]; then
# 		inp=$1
# 	elif [[ $# -eq 0 ]]; then
# 		read inp
# 	else
# 		echo "Usage: copy [string|file_name]"
# 		return 1
# 	fi
# 	if [[ -d `pwd`/$inp ]]; then
# 		echo "Cannot copy. $inp is a directory to clipboard"
# 		return 1
# 	fi
# 	if [[ -a `pwd`/$inp ]]; then
# 		cat $inp | clipcopy
# 		echo "Copied contents of $inp to clipboard"
# 		return 0
# 	fi
# 	echo $inp | clipcopy
# 	echo "Copied \"$inp\" to clipboard"
# }
