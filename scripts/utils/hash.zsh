# Hashes a string. Supports piping -- overwrites builtin hash command
hash() {
	local unparsed
	if [ $# -lt 1 ]; then
		echo "Usage: hash [algorithm] [string]"
		return 1
	fi
	local second=${2:-$(</dev/stdin)}
	if [[ -e $second ]]; then
		unparsed=`openssl $1 $second`
		return
	else
		unparsed=`printf $second | openssl $1`
	fi
	echo ${unparsed#*= }
}