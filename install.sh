#!/bin/bash
set -e


rm -f ~/.zshrc
ln -s ~/.zshconfig/.zshrc ~

# Check if APT is installed
if ! command -v apt >/dev/null 2>&1; then
	echo "Apt not installed"
	exit 1
fi

cd ~
rm -rf ~/.zshconfig
git clone https://Sargates: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@github.com/Sargates/.zshconfig.git

echo Starting install.sh
sudo apt update -y && sudo apt upgrade -y

contains() {
	case $1 in *"$2"*)
		return 0;
	esac
	return 1;
}
# Dependencies
## Zsh
if ! command -v zsh >/dev/null 2>&1; then
	echo "Installing Zsh"
	sudo apt install zsh -y
else
	echo "ZSH is already installed"
fi
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	rm -f ~/.zshrc.pre-oh-my-zsh
	echo "Installing oh-my-zsh"
	# Background OMZ install and wait for completion. This prevents OMZ from overwriting work done in the lines after
	sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" &
	echo $!
	wait $!
else
	echo "OMZ is already installed"
fi
## Git
if ! command -v git >/dev/null 2>&1; then
	echo "Installing Git"
	sudo apt install git -y

	cat ~/.gitconfig >> ~/.gitconfig-old			# Append to old file to prevent data loss
	rm -f ~/.gitconfig
	ln -s ~/.zshconfig/.gitconfig ~/.gitconfig
else
	echo "Git is already installed"
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

	[ -f ~/.tmux.conf ] && cat ~/.tmux.conf >> ~/.tmux-old.conf						# Append to old file to prevent data loss
	rm -f ~/.tmux.conf
	ln -s ~/.zshconfig/.tmux.conf ~/.tmux.conf
	[ -f ~/.tmux.conf.local ] && cat ~/.tmux.conf.local >> ~/.tmux-old.conf.local	# Append to old file to prevent data loss
	rm -f ~/.tmux.conf.local
	ln -s ~/.zshconfig/.tmux.conf.local ~/.tmux.conf.local

	echo "Installing tmux"
	sudo apt install tmux -y
else
	echo "Tmux is already installed"
fi


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
