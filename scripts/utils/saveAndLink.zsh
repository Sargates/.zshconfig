# Appends file contents to .old and makes replaces with a link to file in zshconfig
saveAndLink() {
	local FILE=$1:t DEST=$2
	
	if [ -f "$DEST/$FILE" ]; then
		cat "$DEST/$FILE" >> "$DEST/$FILE.old"
		rm -f "$DEST/$FILE"
	fi

	ln -s "$ZSHCFG/$1" "$DEST/$FILE"	
}