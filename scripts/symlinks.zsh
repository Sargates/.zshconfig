#!/bin/zsh

#* This file ensures symlinks in `~` exist and point to the files in `configs`, also makes dated backups to prevent dataloss

if [ -z $ZDOTDIR ]; then exit 1; fi

#* This `if` will still process even if `ZSH_CONFIG` is actually set but every option is "no". shouldn't matter, just wasteful
if [ -z "$ZSH_CONFIG" ]; then source "$ZDOTDIR/scripts/config.zsh"; fi

mkdir -p $ZDOTDIR/.cache/.old
local neededUpdate="no"

needsUpdate() { # $1 is abs filepath and must be a symlink to work correctly
	[ ! -h "$1" ] && return 0 							# if file is not a symlink, overwrite with symlink
	[[ $(readlink "$1") != "$ZDOTDIR/"* ]] && return 0	# if file is symlink and symlink does not point somewhere in $ZDOTDIR, overwrite with proper symlink
	[ ! -e $(readlink "$1") ] && return 0				# if file is symlink and points somewhere in $ZDOTDIR, but linked file does not exist, then overwrite with proper symlink
	return 1 # returning `1` will not update the symlink. Has to do with how shell script and error codes work.
}

makeBackup() { # $1 is abs filepath, save to $ZDOTDIR/.cache with date
	[ ! -e "$1" ] && return 0 	# if file doesn't exist, don't make backup
	[ -h "$1" ] && return 0 	# if file is already a symlink, no need to backup. return
	mv "$1" "$ZDOTDIR/.cache/.old/$(date +"%m-%d-%Y-%H-%M-%S")${1:t}" #* no space needed between ${1:t} and datetime because its a dotfile, thus -> $DATE.gitconfig
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

		neededUpdate="yes"
		echo "Backing up and linking $HOME/${file:t}"
		makeBackup "$HOME/${file:t}"
		makeLink "$file"
		
	done

	if [ $neededUpdate = "yes" ]; then
		echo 'File backups can be found at `$ZDOTDIR/.cache/.old`'
	fi

}

checkAndUpdate $@