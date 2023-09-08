
alias pip='python -m pip'
alias cd..='cd ..'
alias listapt="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
alias zshrc='source ~/.zshrc'
alias python='python3'
alias ld='~/Desktop'
alias ldesktop='ld'
alias ldesk='ld'
alias debug='source ./test.zsh'


alias zshcfg="code -n ~/.zshconfig"

alias mcd='() { md $1 && cd $_ }'
alias killssh='kill `pgrep ssh-agent`'

setopt globdots
