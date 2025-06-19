export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
#! Only uncomment the following when using Powerlevel10k
# TODO: look into creating instant prompt for headline
# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.


# TODO: Call install/update.zsh here
# Call `git pull` on zsh-syntax-highlighting
# Call `omz update` and make sure omz changelog is accounted for

# git() { #? Debug
# 	echo "$0 $@" > $HOME/Desktop/error.log
# 	command git $@
# }

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="headline"
# ZSH_THEME="agnoster"
# ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true" #* This is adds an ellipsis to the prompt when waiting on tab-completion, tend to be distracting when it doesn't wait long


# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true" #? testing this

# # HEADLINE_RIGHT_PROMPT_ELEMENTS=(status virtualenv) # TODO: remove virtualenv here
# HEADLINE_RIGHT_PROMPT_ELEMENTS=(status)

plugins=(
	git
	virtualenv
	ssh-agent
	aliases
	tailscale
)
(( ${+commands[tmux]} )) && plugins+=(tmux)
(( ${+commands[docker]} )) && plugins+=(docker)

#! This adds a hook to reset the prompt, thus resetting the clock and letting it be read at the time of execution instead of the time of last execution.
#! This also causes the bug of setting the $CURSOR value to EOL, causing issues when traversing history with up/down arrows. there's no way around this as $CURSOR is read-only during the execution of TRAPALRM.
# TMOUT=1; TRAPALRM () { zle reset-prompt }
#* TLDR: SOL on accurate clock for now


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

(( $#commands[nvim] )) && { export EDITOR=nvim; export SUDO_EDITOR=nvim } # `export` is needed here to work properly. maybe because it's being elevated and it's not the same shell??


#* Ex: (( $ISWSL )) && echo "This is WSL" || echo "This is not WSL"
typeset -ix ISWSL # -i defines as integer, -x auto-exports variable. See http://devlib.symbian.slions.net/s3/GUID-D87C96CE-3F23-552D-927C-B6A1D61691BF.html
[[ -a "/proc/sys/fs/binfmt_misc/WSLInterop" ]] && ISWSL=1 || ISWSL=0

# Change ZSH_COMPDUMP location to prevent cluttering user folder
ZSH_CUSTOM=${HOME:-/home/nobody}/.zshconfig
export ZDOTDIR="$HOME/.zshconfig"
builtin hash -d zshcfg="$ZDOTDIR"
# OMZ defines HISTFILE using nullish coalescing. Some terminal environments (VSCode) set $HISTFILE before sourcing .zshrc, causing for the incorrect value to be used in those environments.
if [ -d "$HOME/.zshhistory" ]; then 	export HISTFILE="$HOME/.zshhistory/.zsh_history"
else 									export HISTFILE="$HOME/.zsh_history"; fi
export ZSH="$ZDOTDIR/ohmyzsh"
export ZSH_COMPDUMP="$ZDOTDIR/cache/.zcompdump-${HOST}-${ZSH_VERSION}"
# export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump-${HOST}-${ZSH_VERSION}"
export ZSH_CACHE_DIR="$ZDOTDIR/cache"

export BASH_COMP_DEBUG_FILE=$ZDOTDIR/.cache/bash_comp_debug_file


NVIM="${HOME:-/home/nobody}/.config/nvim"


# export dirstack_file="$ZDOTDIR/cache/.dirpersist" #? Only needed for `dirpersist` plugin

#* https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html
# > `-t fmt` prints time and date stamps in the given format; fmt is formatted with the strftime function with the zsh extensions described for the %D{string} prompt format in Prompt Expansion. The resulting formatted string must be no more than 256 characters or will not be printed
#* strftime formatting: https://pubs.opengroup.org/onlinepubs/007908799/xsh/strftime.html
HIST_STAMPS="%a %b %e %Y %H:%M:%S"
#* omz defines `history` as `"omz_history -t $HIST_STAMPS"`. Must be set before sourcing OMZ

source $ZSH/oh-my-zsh.sh # This line is what ends up sourcing OMZ

# Unset opts set by ohmyzsh/lib/history.zsh. I don't know if this actually works as I think, but I hope so
unsetopt hist_expire_dups_first
unsetopt hist_ignore_dups

#? nvm is a "slow plugin" apparently, commenting this out for testing as I don't use it
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



[ -s "$HOME/.zshconfig/ohmyzsh/plugins/docker/completions/_docker" ] && source "$HOME/.zshconfig/ohmyzsh/plugins/docker/completions/_docker"

# See ohmyzsh/plugins/docker/README.md
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

autoload -Uz compinit
compinit -d $ZSH_COMPDUMP

[ -s "$HOME/.zprofile" ] && source "$HOME/.zprofile" # Source .zprofile for additional, per-system aliases and setup
