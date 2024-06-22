# This file ensures symlinks in `~` exist and point to the files in `configs`

# Not needed to re-link .zshrc because this script wont get 
for file in .zshrc .tmux.conf .tmux.conf.local .gitconfig; do
	[ $needsUpdate ] && break # exit to update symlinks

	local filepath=$HOME/$file
	[ ! -h $filepath ] && needsUpdate=1 												# if file is not a symlink, overwrite with symlink
	[ -z $needsUpdate ] && [[ $(readlink $filepath) != "$ZSHCFG/"* ]] && needsUpdate=1	# if file is symlink and symlink does not point somewhere in $ZSHCFG, overwrite with proper symlink
done

if [ $needsUpdate ]; then
	echo "Updating Symlinks"
	
	# List all files in config directory, run ln on all results
	# Wrapping command in () opens subshell, cd into directory 
	(cd $ZDOTDIR/config && ls -A1) | xargs -l zsh -c 'ln -sf $ZDOTDIR/config/$0 ~/$0'
	ln -sf $ZDOTDIR/.zshrc ~/.zshrc
fi


