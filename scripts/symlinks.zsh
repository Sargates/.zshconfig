#!/bin/zsh

#* This file ensures symlinks in `~` exist and point to the files in `configs`, also makes dated backups to prevent dataloss

if [ -z $ZDOTDIR ]; then exit 1; fi

if [ -z "$ZSH_CONFIG" ]; then source "$ZDOTDIR/scripts/config.zsh"; fi # this will proc even if all the options in the config are "no". shouldn't matter, just wasteful

mkdir -p $ZDOTDIR/.cache/.old

needsUpdate() { # $1 is abs filepath and must be a symlink to work correctly
	[ ! -h "$1" ] && return 0 							# if file is not a symlink, overwrite with symlink
	[[ $(readlink "$1") != "$ZDOTDIR/"* ]] && return 0	# if file is symlink and symlink does not point somewhere in $ZDOTDIR, overwrite with proper symlink
	return 1
}

makeBackup() { # $1 is abs filepath, save to $ZDOTDIR/.cache with date
	[ ! -e "$1" ] && return 0 	# if file doesn't exist, don't make backup
	[ -h "$1" ] && return 0 	# if file is already a symlink, no need to backup. return
	mv "$1" "$ZDOTDIR/.cache/.old/$(date +"%m-%d-%Y-%H-%M-%S")${1:t}"
	# echo "$ZDOTDIR/.cache/.old/$(date +"%m-%d-%Y-%H-%M-%S")${1:t}"
}

makeLink() {
	ln -sf "$1" "$HOME/${1:t}"
}

checkAndUpdate() {
	
	if needsUpdate "$HOME/.zshrc"; then
		makeBackup "$HOME/.zshrc"
		makeLink "$ZDOTDIR/.zshrc"
	fi
	
	typeset -a files=( # Files to link, will make symlinks in $HOME
		$ZDOTDIR/configs/.gitconfig
		$ZDOTDIR/configs/.tmux.conf.local
		$ZDOTDIR/configs/.tmux.conf
	)
	for file in $files; do
		[[ ${file:t} == ".gitconfig"* ]] && (( ! ${+ZSH_CONFIG[link_gitconf]} )) && continue	# If current file is .gitconfig and linking .gitconfig is disabled, skip
		[[ ${file:t} == ".tmux"* ]] && (( ! ${+ZSH_CONFIG[link_tmuxconf]} )) && continue		# If current file is .tmux.conf and linking .tmux.conf is disabled, skip
		# echo Gaming
		if [ $# -eq 0 ] && ! needsUpdate "$HOME/${file:t}"; then continue; fi									# If file doesn't need update, skip

		echo "Backing up and linking ${file:t}"
		makeBackup "$HOME/${file:t}"
		makeLink "$file"
		
	done

}

checkAndUpdate $@