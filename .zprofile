# setopt extended_glob
setopt globdots


alias pip='python -m pip'
alias cd..='cd ..'
alias zshrc='source ~/.zshrc'
alias cdzsh='cd ~/.zshconfig'
# alias python='python3'
# alias debug='source ./test.zsh'

# alias listapt="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
alias haconnect='ssh hassio@homeassistant.local'
alias listapt='apt list --installed'
alias searchapt='apt search'
alias listjava='apt search openjdk-.+-'
alias clip="cut -c 1-`tput cols`"
alias cgrep="clip|grep"

export ZSHCFG="$HOME/.zshconfig"


# Used for mouse functionality in less pagers (git log, nano, etc.) neovim works by default (no idea why)
[[ "${LESS}" != *--mouse* ]] && export LESS="${LESS} --mouse --wheel-lines=2"
# Apparently the above line breaks native windows terminal selection (can't verify because I have no idea what this means, see: https://github.com/microsoft/terminal/issues/9165#issuecomment-1398208221)
# Doesn't matter because of `kbhelper.zsh`'s selection system


rename() {
    if [ $# -ne 2 ]; then
        echo "Usage: rename <old_name> <new_name>"
        return 1
    fi

    local old_name="$1"
    local new_name="$2"

    if [ ! -e "$old_name" ]; then
        echo "Error: '$old_name' does not exist."
        return 1
    fi

    if [ -e "$new_name" ]; then
        echo "Error: '$new_name' already exists."
        return 1
    fi

    mv "$old_name" "$new_name"
    if [ $? -eq 0 ]; then
        echo "Successfully renamed '$old_name' to '$new_name'."
    else
        echo "Failed to rename '$old_name'."
    fi
}


alias zshcfg="code -n ~/.zshconfig"
alias mcd='() { md $1 && cd $_ }'
alias killssh='kill `pgrep ssh-agent`'
