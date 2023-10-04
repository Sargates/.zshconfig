alias glgrep="getGitCommitBySubstring"
alias glg="glgrep"
alias grget='git remote get-url'
alias gl="git log"

getGitCommitBySubstring() {
	git log --pretty=oneline | cat | grep -B 1 -A 1 --color=always -i '.*'$1'.*' | cut -c 1-`tput cols`
}

github() {
  	local REPONAME=$1
	local GHUBUSER=$2
	if [[ "$GHUBUSER" == "" ]]; then
		GHUBUSER="Sargates"
	fi
	echo git@github.com:$GHUBUSER/$REPONAME.git
}

ghpull() {
	local REPONAME=$1
	local GHUBUSER=$2
	if [[ "$GHUBUSER" == "" ]]; then
		GHUBUSER="Sargates"
	fi
	git pull git@github.com:$GHUBUSER/$REPONAME.git
}