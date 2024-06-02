# Appends file contents to .old and makes replaces with a link to file in zshconfig
saveAndLink() {
	local FILE=${1:t} DEST=$2

	# cat "$DEST/$FILE" >> "$DEST/$FILE.old" // TODO: Add this part to install script
	# rm -f "$DEST/$FILE"
	
	if [ ! -f "$DEST/$FILE" ]; then
		ln -s "$ZSHCFG/$1" "$DEST/$FILE"
	fi

}