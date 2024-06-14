#!/bin/bash

echo "clean.bash does not work yet"
return 1
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure you want to clean your zsh setup? [y/n]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

if ! confirm; then
	exit 1
fi

rm -f ~/.zprofile
rm -f ~/.zshrc
rm -f ~/.zshrc.pre-oh-my-zsh*
rm -f ~/.zshrc.omz-uninstalled*
# uninstall_oh_my_zsh #! no idea why this binary isnt appearing anymore
rm -rf ~/.oh-my-zsh
rm -rf ~/.zshconfig