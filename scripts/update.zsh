#!/bin/zsh

# File to ensure that .zshconfig is at the latest version

echo "update.zsh does not work yet"
return 1

echo "Updating .zshconfig"
source "$ZSHCFG/scripts/utils/saveAndLink.zsh" # This script uses functions defined in `utils.zsh`

# Find if remote git repo is ahead. (local version needs update)

ZSHCFG="$HOME/.zshconfig"
cd $ZSHCFG


if [[ `git_commits_behind` ]]; then
	read -q "REPLY?Would you like to update .zshconfig?"
	if [[ $REPLY =~ "[yY]|[yY][eE][sS]" ]]; then

	fi
fi


#* Ensure symlinks are set. Refer to dependencies.txt
# Creates symlinks to the corresponding files in .zshconfig, also caches old to a file
rm -f "$HOME/.zshrc" # Used to prevent a large .zshrc.old file

source $ZSHCFG/scripts/symlinks.zsh


# Ensure dependencies are installed.
