# To prevent duplicate entries
addToPath() {
	[[ "${PATH}" != *$1* ]] && PATH="$PATH:$1"
}

addToPath $HOME/.local/bin
addToPath usr/local/bin
addToPath /usr/share/dotnet
JAVA_HOME=''
if [ -z "$JAVA_HOME" ] && [ ${+commands[java]} ]; then
	JAVA_HOME=`readlink -f $(which java)` # Gets path that the `/bin/java` symlink points to. Will be in the JAVA_HOME folder
	JAVA_HOME=`realpath ${JAVA_HOME:h}/..` # Path is that of the binary, use `:h` to get the directory, concat with "/.." and call `realpath` to simplify
	export JAVA_HOME
else
	
fi
addToPath $JAVA_HOME

export PATH
