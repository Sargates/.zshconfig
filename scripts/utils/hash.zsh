# Hashes a string. Supports piping -- overwrites builtin hash
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
