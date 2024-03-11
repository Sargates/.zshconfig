# Function to get regex match from pattern. Supports piping - Essentially just a wrapper for grep, returns first match
regex() {
	local pattern string
	pattern=$1
	if [[ $# -eq 1 ]]; then
		string=${2:-$(</dev/stdin)}
	else
		echo "Usage: regex [pattern] [string]"
		return 1
	fi
	
	echo "$string" | grep -E -o "$pattern" | head -1
}

