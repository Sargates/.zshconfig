alias glgrep="getGitCommitBySubstring"
alias glg="glgrep"
alias grget='git remote get-url'
alias gl="git lg"
alias gla="git lg --all"
alias gmff="git merge --ff-only"
alias gmnff="git merge --no-ff"

# git config --global user.email "$USER@$HOST" // Was testing this, do not remove unless you want your git signature to be changed

getGitCommitBySubstring() {
	git log --pretty=oneline | cat | grep -B 1 -A 1 --color=always -i '.*'$1'.*'
}

github() {
	if [[ $# -ne 2 && $# -ne 1 ]]; then
		echo 'Usage: github [github-user=Sargates] [repo-name]'
		return 1
	fi
	local REPONAME=""
	local GHUBUSER="Sargates"
	if [[ $# -eq 2 ]]; then
		GHUBUSER=$1
		REPONAME=$2
	fi
	if [[ $# -eq 1 ]]; then
		REPONAME=$1
	fi
	echo git@github.com:$GHUBUSER/$REPONAME.git
}