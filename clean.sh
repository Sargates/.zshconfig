#!/bin/bash

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

rm -f ~/.zshrc
rm -f ~/.zshrc.pre-oh-my-zsh*
rm -f ~/.zshrc.omz-uninstalled*
rm -rf ~/.oh-my-zsh
rm -rf ~/.zshconfig