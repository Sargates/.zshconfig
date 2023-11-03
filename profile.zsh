# setopt extended_glob
setopt globdots


export EDITOR="code"

#! Set aliases
alias pip='python -m pip'
alias zshrc='source ~/.zshrc'
alias cdzsh='cd ~/.zshconfig'

# alias listapt="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
alias haconnect='ssh hassio@homeassistant.local' 		# Connect to local home assisstant server (if exists)
alias listapt='apt list --installed'					# List installed apt packages (optionally use with grep)
alias listjava='apt search openjdk-.+-'					# Search installable JDK's because I can never remember the formatting


alias zshcfg="$EDITOR ~/.zshconfig"						# Open zsh config in VSCode
alias mcd='() { md $1 && cd $_ }'						# Used to create and cd to a new directory
alias killssh='kill `pgrep ssh-agent`' 					# Used to reset ssh-agent
alias clip="cut -c 1-`tput cols`"						# Use with pipe to clip output to terminal size to prevent line wrapping
alias clgrep="clip|grep"								# Use with pipe to have clipped grep output. Buggy; Doesn't match patterns to what was clipped
alias ncgrep="grep --color=never"						# Use with pipe to have clipped grep output. Buggy; Doesn't match patterns to what was clipped
alias l="ls -lah --color=always"						# Preserves coloring when piping to grep with --color=never flag i.e. `l | grep --color=never {PATTERN}`
alias listports="sudo lsof -i -P -n | grep LISTEN"		# Used to list open ports



#! Set configuration

[[ ISWSL -eq 1 ]] && [[ "${LESS}" != *--mouse* ]] && export LESS="${LESS} --mouse" # Used for mouse functionality in less pagers (git log, man, etc.)
#! Above line breaks Windows Terminal selection inside of pagers (git log, man, etc.). See: https://github.com/microsoft/terminal/issues/9165#issuecomment-1398208221
#! Holding shift down prevents this issue, but interaction still works the same (i.e. it might not have the expected behavior)
[[ ISWSL -eq 1 ]] && [[ "${LESS}" != *--wheel-lines=* ]] && export LESS="${LESS} --wheel-lines=2" # Change number of lines per scroll

export LANG="C.UTF-8"									# Change LANG (mainly for sort order when calling ls -l)


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




export ZSHCFG="$HOME/.zshconfig"
