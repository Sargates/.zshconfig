
alias pip='python -m pip'
alias cd..='cd ..'
alias listapt="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
alias zshrc='source ~/.zshrc'
alias python='python3'
# alias debug='source ./test.zsh'

alias haconnect='ssh hassio@homeassistant.local'
alias listapt='apt list --installed'
alias searchapt='apt search'
alias listjava='apt search openjdk-.+-'


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

setopt globdots
