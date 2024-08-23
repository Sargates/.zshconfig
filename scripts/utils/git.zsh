#* Custom aliases for git-related commands - Mainly ones that aren't provided by OMZ

unalias grset 2> /dev/null
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
	git log --all --color=always --pretty=$'%C(bold blue)%h%C(reset)\t%C(bold cyan)%aD%C(reset)\t%C(white)%s%C(reset)%C(dim white) - %an%C(reset)' | GREP_COLORS="ms=41" grep -i $* --color=always -A1 -B1 | column_ansi -t -s $'\t' | trim
	# Need to call `trim` (see profile.zsh for definition) after `column_ansi` (see scripts/column_ansi) to trim trailing newline
}
alias glg="glgrep"

function github() {
	local REPONAME=""
	local GHUBUSER='Sargates'		# Default name

	if [[ $# -ne 2 && $# -ne 1 ]]; then # Show usage
		echo "Usage: github [github-user=$GHUBUSER] [repo-name]"
		return 1
	fi

	# Set parameters according to number of passed args
	if [[ $# -eq 2 ]]; then
		GHUBUSER=$1
		REPONAME=$2
	fi
	if [[ $# -eq 1 ]]; then
		REPONAME=$1
	fi


	#* If a repository is public, its preferable to use http, then you dont need to have any ssh identities added if you're on a new system.
	#* If its not public, then use an `ssh` address as the easiest way to access private repos is through SSH. 


	# If `curl` or `jq` is not installed, abort and return the ssh address. These binaries would be automatically installed by `install.bash`
	if (( ! ${+commands[curl]}${+commands[jq]} )); then
		echo git@github.com:$GHUBUSER/$REPONAME.git
		return;
	fi

	#* To check if a repo is public, query github's API to see if the repo is accessible with no authentication.
	if [ $(curl https://api.github.com/repos/$GHUBUSER/$REPONAME 2>/dev/null | jq '.["private"]') = "false" ]; then
		# Repository is public, return https URL
		echo https://github.com/$GHUBUSER/$REPONAME.git
	else
		# Repository is private or does not exist, return ssh address
		echo git@github.com:$GHUBUSER/$REPONAME.git
	fi
}

#* Calling `github` queries GitHub's API for whether a repo exists, this can cause unexpected behavior. 
#* Worst case scenario, `gitlab` will return an ssh address and not an https URL
function gitlab() { # Fork of `github` for gitlab
	echo `github $@` | sed 's/github/gitlab/'
}