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

