#!/bin/bash
set -e

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
	touch ~/.zshrc # To get zsh to shut up on next restart just in case
fi
## Git
if ! command -v git >/dev/null 2>&1; then
	echo "Installing Git"
	sudo apt install git -y
fi
# If is not WSL instance, install xsel (needed for cutting and copying from native ZSH selection buffer)
if [[ ! -a "/etc/wsl.conf" ]]; then
	echo "Installing Xsel"
	sudo apt install xsel -y
fi

## Python3.X
if ! command -v python3 >/dev/null 2>&1; then
	echo "Input python version 3.X to install (n to skip install)"
	while true; do
		read pv
		if [ "$pv" = "" ]; then
			echo "Installing latest Python"
			sudo apt install python3 -y
			break
		elif contains "11 10 9 8 7 6 5 4 3 2 1 0" "$pv"; then
			echo "Installing Python 3.$pv"
			sudo apt install python3.$pv -y
			break
		elif [ "$pv" = "n" ]; then
			echo "Python install skipped"
			break
		else
			echo "Invalid version Python 3.$pv, try again"
		fi
	done
fi

if ! command -v omz >/dev/null 2>&1; then
	echo "Installing oh-my-zsh"
	# Background OMZ install and wait for completion. This prevents OMZ from overwriting work done in the lines after
	pid=`sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" &`
	echo $!
	wait $!
fi

rm -f ~/.zshrc.pre-oh-my-zsh
rm -f ~/.zshrc
ln -s ~/.zshconfig/.zshrc ~


