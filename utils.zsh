# Function to get regex match from pattern. Supports piping
regex() {
	local string pattern
	if [[ $# -eq 2 ]]; then
		string=$1
		pattern=$2
	elif [[ $# -eq 1 ]]; then
		pattern=$1
		read -r string
	else
		echo "Usage: regex [string] [pattern]"
		return 1
	fi
	
	out=`echo "$string" | grep "$pattern" | head -1`
	echo $out
}


# Copy a string or a file's contents to clipboard. Supports piping
copy() {
	local inp
	if [[ $# -eq 1 ]]; then
		inp=$1
	elif [[ $# -eq 0 ]]; then
		read inp
	else
		echo "Usage: copy [string|file_name]"
		return 1
	fi
	if [[ -d `pwd`/$inp ]]; then
		echo "Cannot copy. $inp is a directory to clipboard"
		return 1
	fi
	if [[ -a `pwd`/$inp ]]; then
		cat $inp | clipcopy
		echo "Copied contents of $inp to clipboard"
		return 0
	fi
	echo $inp | clipcopy
	echo "Copied \"$inp\" to clipboard"
}

# Hashes a string. Supports piping
hash() {
	local alg inp
	if [[ $# -eq 2 ]]; then
		alg=$1
		inp=$2
	elif [[ $# -eq 1 ]]; then
		alg=$1
		read -r inp
	else
		echo "Usage: hash [algorithm] [string]"
		return 1
	fi
	local unparsed=`echo -n $inp | openssl $alg`
	local out=${unparsed#*= }
	echo $out
}

# Renames a file or directory. Used to have some issues inside WSL but haven't had them recently and restarting WSL one or more times always fixed them.
rename() {
    if [ $# -ne 2 ]; then
        echo "Usage: rename <old_name> <new_name>"
        return 1
    fi

    local old_name="$1"
    local new_name="$2"

    if [ ! -e "$old_name" ]; then
        echo "Error: '$old_name' does not exist."
        return 1
    fi

    if [ -e "$new_name" ]; then
        echo "Error: '$new_name' already exists."
        return 1
    fi

    mv "$old_name" "$new_name"
    if [ $? -eq 0 ]; then
        echo "Successfully renamed '$old_name' to '$new_name'."
    else
        echo "Failed to rename '$old_name'."
    fi
}
