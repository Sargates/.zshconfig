#* Custom aliases for git-related commands - Mainly ones that aren't provided by OMZ

unalias grset
grset() {
	if [[ $(git rev-parse --is-inside-work-tree) != "true" ]]; then
		return 128
	fi

	if [[ $# -lt 2 ]]; then
		echo 'Sets remote to address, adds remote by nameif not already set'
		echo 'Usage "grset <remote-name> <remote-address>"'
		return 1
	fi

	if [[ $(git remote | grep "$1") == "" ]] then
		# echo "Remote was not found, adding. \"$1\", \"$2\""
		git remote add "$1" "$2"
		return 0
	fi
	# echo "Remote found, setting address. $1, $2"
	git remote set-url "$1" "$2"
}
alias grget='git remote get-url'	#? OMZ defines `grset` but no `grget` ???
alias gl="git lg" 					#? OMZ's `gl` is for `git pull`		  ???
alias gla="git lg --all"			# Show all refs in git log
alias gmff="git merge --ff-only"	# shorthand for ff merge
alias gmnff="git merge --no-ff"		# shorthand for no-ff merge

# git config --global user.email "$USER@$HOST" #! Was testing this, do not uncomment unless you want your git signature to be changed

function glgrep() { # See: https://askubuntu.com/q/1502183/1764786 for extra info
	git log --all --color=always --pretty=$'%C(bold blue)%h%C(reset)\t%C(bold cyan)%aD%C(reset)\t%C(white)%s%C(reset)%C(dim white) - %an%C(reset)' | GREP_COLORS="ms=41" grep -i $1 --color=always -A1 -B1 | column_ansi -t -s $'\t' | trim
	# Need to call `trim` (see profile.zsh for definition) after `column_ansi` (see scripts/column_ansi) to trim trailing newline
}
alias glg="glgrep"

function github() {
	local default='Sargates'
	if [[ $# -ne 2 && $# -ne 1 ]]; then
		echo "Usage: github [github-user=$default] [repo-name]"
		return 1
	fi
	local REPONAME=""
	local GHUBUSER=$default		# Default name
	if [[ $# -eq 2 ]]; then
		GHUBUSER=$1
		REPONAME=$2
	fi
	if [[ $# -eq 1 ]]; then
		REPONAME=$1
	fi
	echo git@github.com:$GHUBUSER/$REPONAME.git
}
function gitlab() { # Fork of `github` for gitlab
	echo `github $@` | sed 's/github/gitlab/'
}