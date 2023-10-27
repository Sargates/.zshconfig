# To prevent duplicate entries
addToPath() {
	[[ "${PATH}" != *$1* ]] && PATH="$PATH:$1"
}

addToPath $HOME/.local/bin
addToPath usr/local/bin
addToPath /usr/share/dotnet
export JAVA_HOME="/usr/lib/jvm/java-19-openjdk-amd64"
addToPath $JAVA_HOME

export PATH
