#! Doesn't work with `nvm`. `nvm` is POSIX compliant so it can't use `builtin` to reference the ZSH builtin `hash` command, so the nvm script ends up calling this function instead, causing issues when using nvm at all.
# Hashes a string. Supports piping -- overwrites builtin hash command
# hash() {
# 	local unparsed
# 	if [ $# -lt 1 ]; then
# 		echo "Usage: hash [algorithm] [string]"
# 		return 1
# 	fi
# 	local second=${2:-$(</dev/stdin)}
# 	if [[ -e $second ]]; then
# 		unparsed=`openssl $1 $second`
# 		return
# 	else
# 		unparsed=`printf $second | openssl $1`
# 	fi
# 	echo ${unparsed#*= }
# }