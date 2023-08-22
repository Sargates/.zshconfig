# !/bin/bash
set -e

# COMMAND TO RUN: `sh -c "$(wget https://raw.githubusercontent.com/Sargates/.zshconfig/master/install.sh -O -)"`


echo Starting install.sh
sudo echo

contains() {
	case $1 in *"$2"*)
		return 0;
	esac
	return 1;
}
# Dependencies
if ! command -v zsh >/dev/null 2>&1; then
	echo "Installing zsh"
	sudo apt install zsh -y
	touch ~/.zshrc # To get zsh to shut up on next restart just in case
fi
if ! command -v git >/dev/null 2>&1; then
	echo "Installing git"
	sudo apt install git -y
fi
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
	sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
fi



rm -- "$0"
