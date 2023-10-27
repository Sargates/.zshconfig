#!/bin/bash
set -e

# Check if APT is installed
if ! command -v apt >/dev/null 2>&1; then
	echo "Apt not installed"
	exit 1
fi

echo Starting install.sh


# returns true if first string contains second string
contains() {
	case $1 in *"$2"*)
		return 0;
	esac
	return 1;
}

ZSHCFG="$HOME/.zshconfig"

# appends file contents to .old and makes replaces with a link to file in zshconfig
saveAndLink() {
	if [ -f "$HOME/$1" ]; then
		cat "$HOME/$1" >> "$HOME/$1.old"
		rm "$HOME/$1"
	fi

	ln -s "$ZSHCFG/$1" "$HOME/$1"	
}


# Dependencies

## Git
if ! command -v git >/dev/null 2>&1; then
	echo "Installing Git"
	sudo apt install git -y
else
	echo "Git is already installed"
fi

## Zsh
if ! command -v zsh >/dev/null 2>&1; then
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
if ! command -v bc >/dev/null 2>&1; then
	echo "Installing Basic Calculator"
	sudo apt install bc -y
else
	echo "Basic Calculator is already installed"
fi

## Xsel (needed for cutting and copying from native ZSH selection buffer)
if ! command -v xsel >/dev/null 2>&1; then
	echo "Installing Xsel"
	sudo apt install xsel -y
else
	echo "Xsel is already installed"
fi

## Tmux
if ! command -v tmux >/dev/null 2>&1; then
	echo "Installing tmux"
	sudo apt install tmux -y
else
	echo "Tmux is already installed"
fi



cd "$HOME"

#* Cache Any unstaged/uncommited changes to prevent data loss (this actually happened to me because I ran this fucking script)
#! Note, add functionality to cache "further along" branches. Caching .git directly? Current behaviour would lose unpushed commits
# Export the stashes
mkdir -p "$ZSHCFG"-patches

git -C "$ZSHCFG" stash -q

for ((i = 0; i < `git -C "$ZSHCFG" stash list | wc -l`; i++)); do
	git -C "$ZSHCFG" stash show -p "stash@{$i}" > "$ZSHCFG"-patches/stash$i.patch
done


rm -rf "$ZSHCFG"
git clone https://Sargates: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@github.com/Sargates/.zshconfig.git


# Import the stashes
for stashToApply in "$ZSHCFG"-patches/*; do
	git -C "$ZSHCFG" apply "$stashToApply"
	git -C "$ZSHCFG" stash
done



# This block iterates over all remote branches and fetches each of them to the local repo
for branch in `git -C "$ZSHCFG" branch -r | cat | grep "origin/" | tail -n +2 | sed 's/origin\///'`; do
	if [ "$branch" = "master" ]; then continue; fi
	git -C "$ZSHCFG" fetch origin "$branch":"$branch"
done
# All this does is gets the name of the branch that the most recent commit belongs to and calls `git checkout` on it
git -C "$ZSHCFG" checkout "`git -C "$ZSHCFG" log -1 --all --format="%D" | tr ", " "\n" | grep "origin" | sed 's/origin\///'`"

# All this part is meant to automatically get the most recent version for testing purposes

sudo apt update -y && sudo apt upgrade -y


rm -f "$HOME/.zshrc"
ln -s "$ZSHCFG/.zshrc" "$HOME/.zshrc"


# Creates symlinks to the corresponding files in .zshconfig, also caches old to a file
saveAndLink ".gitconfig"
saveAndLink ".tmux.conf"
saveAndLink ".tmux.conf.local"



# Niceties

## Python3.X
if ! command -v python3 >/dev/null 2>&1; then
	echo "Input python version 3.X to install (n to skip install)"
	while true; do
		read -r pv
		if [ "$pv" = "" ]; then
			echo "Installing latest Python"
			sudo apt install python3 -y
			break
		elif contains "11 10 9 8 7 6 5 4 3 2 1 0" "$pv"; then
			echo "Installing Python 3.$pv"
			sudo apt install python3."$pv" -y
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
