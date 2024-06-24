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
	
	# List all files in config directory, pass to xargs to run command on each result
	# Wrapping command in () opens subshell, cd into directory
	(cd $ZDOTDIR/config && ls -A1) | xargs -l zsh -c 'cat $ZDOTDIR/config/$0 >> $ZDOTDIR/.cache/$0.old'	# Make backup of old file
	(cd $ZDOTDIR/config && ls -A1) | xargs -l zsh -c 'ln -sf $ZDOTDIR/config/$0 ~/$0'					# Make symlink in $HOME
	
	# Do same with .zshrc, not in `config` so needs to be done separately
	cat $ZDOTDIR/config/.zshrc >> $ZDOTDIR/.cache/.zshrc.old
	ln -sf $ZDOTDIR/.zshrc ~/.zshrc
fi


