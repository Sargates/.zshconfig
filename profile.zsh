#!/bin/zsh

#! This script should be loaded automatically by OMZ because it is stored in $ZSHCUSTOM. In this script, hand

# setopt extended_glob
setopt globdots

export ZSHCFG="$HOME/.zshconfig"


#! Set aliases
alias pip='python -m pip'
alias zshrc='source ~/.zshrc'
alias cdzsh='cd ~/.zshconfig'

# alias listapt="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
alias haconnect='ssh hassio@homeassistant.local' 				# Connect to local home assisstant server (if exists)
alias listapt='apt list --installed'							# List installed apt packages (optionally use with grep)
alias listjava='apt search openjdk-.+-'							# Search installable JDK's because I can never remember the title format

#* Set configuration
local baseLS="ls -lah --color=always"							# Preserves coloring when piping to grep with --color=never flag i.e. `l | grep --color=never {PATTERN}`
alias l="$baseLS --group-directories-first"						# Primary "ls" command, groups dirs first, top->bottom: .dirs, dirs, .files, files
export LANG="C.UTF-8"											# Change LANG (mainly for sort order when calling ls -l)
export EDITOR="code"											# Use VSCode as primary EDITOR

alias zshcfg="$EDITOR ~/.zshconfig"								# Open zsh config in editor
alias mcd='() { md $1 && cd $_ }'								# Used to create and cd to a new directory in one command
alias killssh='kill `pgrep ssh-agent`'							# Used to reset ssh-agent
function clip() { cut -c 1-`tput cols` }						# Use with pipe to clip output to terminal size to prevent line wrapping
alias clgrep="clip|grep"										# Use with pipe to have clipped grep output. Buggy; Doesn't match patterns to what was clipped
alias ncgrep="grep --color=never"								# Grep with no color
alias listports="sudo lsof -i -P -n | grep LISTEN"				# Used to list open ports -- useful for being paranoid :)
alias repromptssh="source $ZSHCFG/scripts/utils/ssh.zsh"		# Re-source `ssh.zsh` to reprompt the adding of keys

alias mv="command mv -n"										# Prevent file overwriting, this shit happens too often

alias lrt="$baseLS -t -r"										# Used to list items in directory and sort by time-last-modified. `-r` causes most recent file to be at bottom of output
alias ltr="lrt"													# autocorrect for lrt


alias trim="sed 's/^[ \t]*//;s/[ \t]*$//'"						# Trim leading and trailing whitespace


ZSH_COMPDUMP="$HOME/.zcompdump_archive/.zcompdump-WSL00-NG-5.8.1"




# Recursive Sourcing
for f in $HOME/.zshconfig/scripts/**/*.zsh(D); do # Recursively source all `.zsh` files inside the `scripts` folder
	if [ -d $f ]; then continue; fi
	# if [[ ${f:h:t} == "utils" ]] && [[ ! ${f:t} == "utils.zsh" ]]; then continue; fi #! testing command
	file=$f:t
	ext=$f:t:e


	if [[ $ext == "zsh" ]]; then
		if [[ $file == "update.zsh" ]]; then continue; fi 					# Ignore sourcing `update.zsh`
		if [[ $ISWSL -eq 1 && $file == "linux.zsh" ]]; then continue; fi	# Avoid sourcing `linux.zsh` on WSL
		if [[ $ISWSL -eq 0 && $file == "wsl.zsh" ]]; then continue; fi		# Avoid sourcing `wsl.zsh` on Linux
		source "$f"
	fi;
done

# Syntax highlighting
source "$ZSHCFG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


