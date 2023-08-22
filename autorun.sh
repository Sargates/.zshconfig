#!/bin/bash
set -e

echo Starting autorun.sh
sudo echo


if ! command -v zsh >/dev/null 2>&1; then
	sudo apt install zsh -y
fi
if ! command -v git >/dev/null 2>&1; then
	sudo apt install git -y
fi

contains() {
	case $1 in *"$2"*)
		return 0;
	esac
	return 1;
}

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


