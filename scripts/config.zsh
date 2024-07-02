#!/bin/zsh

if [ -z $ZDOTDIR ]; then exit 1; fi

#* Initializes the ZSH_CONFIG associative array to configure how this configuration will behave.

if [ ! -e "$ZDOTDIR/.zshconfig.json" ]; then
	cp $ZDOTDIR/install/defaults.json $ZDOTDIR/.zshconfig.json
fi


if [ ! -z $ZDOTDIR ] && [[ ${+commands[jq]} ]]; then
	
	# https://stackoverflow.com/a/26717401
	unset ZSH_CONFIG > /dev/null
	declare -Ax ZSH_CONFIG
	while IFS="=" read -r key value; do
		[ $value = 'no' ] && continue # continue if $value == 'no', this is for easier checking of the active configuration using ${+ZSH_CONFIG[$option]}
		ZSH_CONFIG[$key]="$value"
	done < <(cat $ZDOTDIR/.zshconfig.json | sed 's/\/\/.*//' | sed 's/^[ \t]*//;s/[ \t]*$//' | jq -r 'to_entries|map("\(.key)=\(.value)")|.[]')
	#? sed 's/\/\/.*//'					- Remove comments
	#? sed 's/^[ \t]*//;s/[ \t]*$//'	- Trim whitespace
fi