#!/bin/bash
set -e

echo "install.bash does not work yet"
return 1
# mapfile -t dependencies < dependencies.txt

# Check if APT is installed
if "${+commands[apt]}"; then
	echo "Apt not installed. Apt is required to run this script"
	exit 1
fi
sudo echo Starting install.bash



#* Note to self: Don't try to redirect this to null. It's fine here
sudo apt update -y && sudo apt upgrade -y


# returns true if first string contains second string
contains() {
	case $1 in *"$2"*)
		return 0;
	esac
	return 1;
}

ZSHCFG="$HOME/.zshconfig"


# Dependencies

## Git
if "${+commands[git]}"; then
	echo "Installing Git"
	sudo apt install git -y
else
	echo "Git is already installed"
fi

## Zsh
if "${+commands[zsh]}"; then
	echo "Installing Zsh"
	sudo apt install zsh -y
else
	echo "ZSH is already installed"
fi

## OMZ
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	rm -f "$HOME/.zshrc.pre-oh-my-zsh"
	echo "Installing oh-my-zsh"
	# Background OMZ install and wait for completion. This prevents OMZ from overwriting work done in the lines after
	sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" &
	echo $!
	wait $!
else
	echo "OMZ is already installed"
fi

## BC (Basic Calculator)
if "${+commands[bc]}"; then
	echo "Installing Basic Calculator"
	sudo apt install bc -y
else
	echo "Basic Calculator is already installed"
fi

## Xsel (needed for cutting and copying from native ZSH selection buffer)
if "${+commands[xsel]}"; then
	echo "Installing Xsel"
	sudo apt install xsel -y
else
	echo "Xsel is already installed"
fi

## Tmux
if "${+commands[tmux]}"; then
	echo "Installing tmux"
	sudo apt install tmux -y
else
	echo "Tmux is already installed"
fi
## Bat
if "${+commands[batcat]}"; then
	echo "Installing bat"
	sudo apt install bat -y
	sudo ln -s /bin/batcat /bin/bat
else
	echo "Bat is already installed"
fi


## Python3.X
if "${+commands[python3]}"; then
	echo "Input python version 3.X to install (n to skip install)"
	while true; do
		read -r pv
		if [ "$pv" = "" ]; then
			echo "Installing latest Python"
			sudo apt install python3 -y
			sudo apt install python3-pip
			sudo ln -s /bin/python3 /bin/python # Create symlink for `python` interpretation
			break
		elif contains "11 10 9 8 7 6 5 4 3 2 1 0" "$pv"; then
			echo "Installing Python 3.$pv"
			sudo apt install python3."$pv" -y
			sudo apt install python3-pip
			sudo ln -s /bin/python3 /bin/python # Create symlink for `python` interpretation
			break
		elif [ "$pv" = "n" ]; then
			echo "Python install skipped"
			break
		else
			echo "Invalid version Python 3.$pv, try again"
		fi
	done
else
	echo "Python is already installed" #! Note, add python version
fi




cd "$HOME"

#* This Caches any unstaged/uncommited changes to prevent data loss (this actually happened to me because I ran this fucking script)
#! Note, add functionality to cache "further along" branches. Caching .git directly? Current behaviour would lose unpushed commits

hadPatches=0
if [ -d "$ZSHCFG" ]; then
	# Export the stashes

	rm -rf "$ZSHCFG-patches"
	mkdir -p "$ZSHCFG-patches"
	hadPatches=1

	git -C "$ZSHCFG" stash -q

	[ "`git -C "$ZSHCFG" stash list | wc -l`" -gt 0 ] && echo "Stash(es) found in repository"
	for ((i=0; i < "`git -C "$ZSHCFG" stash list | wc -l`"; i++))
	do
		git -C "$ZSHCFG" stash show -p "stash@{$i}" > "$ZSHCFG-patches/stash$i.patch"
	done

	if [ "`ls -1 "$ZSHCFG-patches" | wc -l`" -eq 0 ]; then
		rm -rf "$ZSHCFG-patches"
		hadPatches=0
	fi

fi

rm -rf "$ZSHCFG"
git clone https://Sargates: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@github.com/Sargates/.zshconfig.git

if [ $hadPatches -eq 1 ]; then

	# Import the stashes
	for stashToApply in "$ZSHCFG-patches"/*; do
		git -C "$ZSHCFG" apply "$stashToApply" > /dev/null 2>&1
		git -C "$ZSHCFG" stash -q
	done

	# This block iterates over all remote branches and fetches each of them to the local repo
	for branch in `git -C "$ZSHCFG" branch -r | cat | grep "origin/" | tail -n +2 | sed 's/origin\///'`; do
		if [ "$branch" = "master" ]; then continue; fi
		git -C "$ZSHCFG" fetch origin "$branch":"$branch"
	done
	echo "Finished pulling branches"
	# All this does is gets the name of the branch that the most recent commit belongs to and calls `git checkout` on it

	rm -rf "$ZSHCFG-patches"

fi

# All this part does is automatically retrieve and checkout the most recent commit for testing purposes
git -C "$ZSHCFG" checkout "$(git -C "$ZSHCFG" log -1 --remotes --format="%D" | tr ", " "\n" | grep "origin" | grep -v "HEAD" | sed 's/origin\///' | head -n 1)"






if [ $hadPatches -eq 1 ]; then
	echo "You had uncommited changes in .zshconfig before installation. They were automatically cached and applied to the new installed"
fi


# Exec `update.zsh` to ensure everything is installed correctly
zsh "$ZSHCFG/update.zsh"