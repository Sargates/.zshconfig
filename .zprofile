
alias pip='python -m pip'
alias cd..='cd ..'
alias listapt="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
alias zshrc='source ~/.zshrc'
alias python='python3'
alias ld='~/Desktop'
alias ldesktop='ld'
alias ldesk='ld'


alias zshcfg="code -n ~/.zshconfig"

alias mcd='() { md $1 && cd $_ }'
alias killssh='kill `pgrep ssh-agent`'

setopt globdots

plugins=(
	git
	virtualenv
	virtualenvwrapper
)
sed -i "s/\/usr\/local/\$HOME\/.local/g" $ZSH/plugins/virtualenvwrapper/virtualenvwrapper.plugin.zsh
sed -i "s/\/usr\/local/\$HOME\/.local/g" $ZSH/plugins/git/git.plugin.zsh

HEADLINE_RIGHT_PROMPT_ELEMENTS=(status virtualenv)


