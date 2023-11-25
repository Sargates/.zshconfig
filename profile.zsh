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


#* Set configuration
alias trim="sed 's/^[ \t]*//;s/[ \t]*$//'"				# Trim leading and trailing whitespace


export LANG="C.UTF-8"									# Change LANG (mainly for sort order when calling ls -l)

export ZSHCFG="$HOME/.zshconfig"

# Syntax highlighting
source "$ZSHCFG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


