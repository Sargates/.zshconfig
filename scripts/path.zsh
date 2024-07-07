# To prevent duplicate entries
addToPath() {
	[[ "${PATH}" != *$1* ]] && PATH="$1:$PATH"
}

# addToPath $HOME/.local/bin # Seems to only be used by python
addToPath /usr/share/dotnet
if [ -z "$JAVA_HOME" ] && (( ${+commands[java]} )); then
	JAVA_HOME=`readlink -f $(which java)` # Gets path that the `/bin/java` symlink points to. Will be in the JAVA_HOME folder
	JAVA_HOME=`realpath ${JAVA_HOME:h}/..` # Path is that of the binary, use `:h` to get the directory, concat with "/.." and call `realpath` to simplify
	export JAVA_HOME
	addToPath $JAVA_HOME/bin
fi
addToPath $BUN_INSTALL # defined in `.zshrc` for bunjs runtime

export PATH
