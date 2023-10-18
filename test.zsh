#* Copied from StackOverflow
#* Ref: https://stackoverflow.com/a/71453634


# for my own convenience I explicitly set the signals
#   that my terminal sends to the shell as variables.
#   you might have different signals. you can see what
#   signal each of your keys sends by running `$> cat`
#   and pressing keys (you'll be able to see most keys)
#   also some of the signals sent might be set in your 
#   terminal emulator application/program
#   configurations/preferences. finally some terminals
#   have a feature that shows you what signals are sent
#   per key press.
#
# for context, at the time of writing these variables are
#   set for the kitty terminal program, i.e these signals  
#   are mostly ones sent by default by this terminal.
# export KEY_ALT_F='ƒ'
# export KEY_ALT_B='∫'
# export KEY_ALT_D='∂'

export KEY_LEFT=$'^[[D'
export KEY_RIGHT=$'^[[C'
export KEY_DELETE=$'^[[3~'

export KEY_CTRL_RIGHT=$'^[[C'
export KEY_CTRL_LEFT=$'^[[D'
export KEY_SHIFT_UP='^[[1;2A'
export KEY_SHIFT_DOWN='^[[1;2B'
export KEY_SHIFT_RIGHT=$'^[[1;2C'
export KEY_SHIFT_LEFT=$'^[[1;2D'
export KEY_SHIFT_CTRL_RIGHT=$'^[[1;6C'
export KEY_SHIFT_CTRL_LEFT=$'^[[1;6D'

export KEY_ALT_LEFT=$'^[f'				# Used for compatability for environments that dont have a home/end key
export KEY_ALT_RIGHT=$'^[b'				# Used for compatability for environments that dont have a home/end key
export KEY_SHIFT_ALT_LEFT=$'^[[1;4D'	# Used for compatability for environments that dont have a home/end key
export KEY_SHIFT_ALT_RIGHT=$'^[[1;4C'	# Used for compatability for environments that dont have a home/end key

export KEY_CTRL_U='^U' # ^U
export KEY_CTRL_BACKSPACE='^H'
export KEY_CTRL_DELETE='5~'
export KEY_CTRL_Z='^Z'
export KEY_CTRL_R='^R' # ^R
export KEY_CTRL_C='^C'
export KEY_CTRL_X='^X'
export KEY_CTRL_V='^V'
export KEY_CTRL_A='^A'
export KEY_CTRL_L='^L' # ^L
export KEY_SHIFT_CTRL_Z='^[[122;6'
# export KEY_SHIFT_CTRL_LEFT=$'^[[1;10D'
# export KEY_SHIFT_CTRL_RIGHT=$'^[[1;10C'
# export KEY_CTRL_A=$'\x01' # ^A
# export KEY_CTRL_E=$'\x05' # ^E
# export KEY_SHIFT_CTRL_A=$'^[[97;6u'
# export KEY_SHIFT_CTRL_E=$'^[[101;6u'
# export KEY_CTRL_D=$'\x04' # ^D

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# copy selected terminal text to clipboard
zle -N widget::copy-selection
function widget::copy-selection {
	if ((REGION_ACTIVE)); then
		zle copy-region-as-kill
		printf "%s" $CUTBUFFER | pbcopy
	fi
}

# cut selected terminal text to clipboard
zle -N widget::cut-selection
function widget::cut-selection() {
	if ((REGION_ACTIVE)) then
		zle kill-region
		printf "%s" $CUTBUFFER | pbcopy
	fi
}

# paste clipboard contents
zle -N widget::paste
function widget::paste() {
	((REGION_ACTIVE)) && zle kill-region
	RBUFFER="$(clip.exe)${RBUFFER}"
	CURSOR=$(( CURSOR + $(echo -n "$(clip.exe)" | wc -m | bc) ))
}

# select entire prompt
zle -N widget::select-all
function widget::select-all() {
	local buflen=$(echo -n "$BUFFER" | wc -m | bc)
	CURSOR=$buflen   # if this is messing up try: CURSOR=9999999
	zle set-mark-command
	while [[ $CURSOR > 0 ]]; do
		zle beginning-of-line
	done
}

# scrolls the screen up, in effect clearing it
zle -N widget::scroll-and-clear-screen
function widget::scroll-and-clear-screen() {
	printf "\n%.0s" {1..$LINES}
	zle clear-screen
}

function widget::util-select() {
	((REGION_ACTIVE)) || zle set-mark-command
	local widget_name=$1
	shift
	zle $widget_name -- $@
}

function widget::util-unselect() {
	REGION_ACTIVE=0
	local widget_name=$1
	shift
	zle $widget_name -- $@
}

function widget::util-delselect() {
	if ((REGION_ACTIVE)) then
		zle kill-region
	else
		local widget_name=$1
		shift
		zle $widget_name -- $@
	fi
}

function widget::util-insertchar() {
	((REGION_ACTIVE)) && zle kill-region
	RBUFFER="${1}${RBUFFER}"
	zle forward-char
}

#                       |  key sequence                   | command
# --------------------- | ------------------------------- | -------------

bindkey					$KEY_ALT_F						forward-word
bindkey					$KEY_ALT_B						backward-word

bindkey 				$KEY_CTRL_DELETE 				kill-word
bindkey					$KEY_CTRL_BACKSPACE				backward-kill-line
bindkey					$KEY_CTRL_Z						undo
bindkey					$KEY_SHIFT_CTRL_Z				redo

bindkey					$KEY_CTRL_C						widget::copy-selection
bindkey					$KEY_CTRL_X						widget::cut-selection
bindkey					$KEY_CTRL_V						widget::paste
bindkey					$KEY_CTRL_A						widget::select-all
# bindkey					$KEY_CTRL_L						widget::scroll-and-clear-screen

for keyname        kcap   seq                   mode        widget (

	# right				kcuf1	$KEY_RIGHT				unselect	forward-char
	# left				kcub1	$KEY_LEFT				unselect	backward-char

	# shift-up			kri		$KEY_SHIFT_UP			select		up-line-or-history
	# shift-down			kind	$KEY_SHIFT_DOWN			select		down-line-or-history
	# shift-right			kRIT	$KEY_SHIFT_RIGHT		select		forward-word
	# shift-left			kLFT	$KEY_SHIFT_LEFT			select		backward-word

	# alt-right			x		$KEY_ALT_RIGHT			unselect	end-of-line
	# alt-left			x		$KEY_ALT_LEFT			unselect	beginning-of-line
	# shift-alt-right		x		$KEY_SHIFT_ALT_RIGHT	select		end-of-line
	# shift-alt-left		x		$KEY_SHIFT_ALT_LEFT		select		beginning-of-line

	# ctrl-right			x		$KEY_CTRL_RIGHT			unselect	forward-word
	# ctrl-left			x		$KEY_CTRL_LEFT			unselect	backward-word
	# shift-ctrl-right	x		$KEY_SHIFT_CTRL_RIGHT	select		forward-word
	# shift-ctrl-left		x		$KEY_SHIFT_CTRL_LEFT	select		backward-word

	# ctrl-e				x		$KEY_CTRL_E				unselect	end-of-line
	# ctrl-a				x		$KEY_CTRL_A				unselect	beginning-of-line
	# shift-ctrl-e		x		$KEY_SHIFT_CTRL_E		select		end-of-line
	# shift-ctrl-a		x		$KEY_SHIFT_CTRL_A		select		beginning-of-line
	# shift-ctrl-right	x		$KEY_SHIFT_CTRL_RIGHT	select		end-of-line
	# shift-ctrl-left		x		$KEY_SHIFT_CTRL_LEFT	select		beginning-of-line

	# del					x		$KEY_DELETE				delselect	delete-char

	# a                 x       'a'               insertchar  'a'
	# b                 x       'b'               insertchar  'b'
	# c                 x       'c'               insertchar  'c'
	# d                 x       'd'               insertchar  'd'
	# e                 x       'e'               insertchar  'e'
	# f                 x       'f'               insertchar  'f'
	# g                 x       'g'               insertchar  'g'
	# h                 x       'h'               insertchar  'h'
	# i                 x       'i'               insertchar  'i'
	# j                 x       'j'               insertchar  'j'
	# k                 x       'k'               insertchar  'k'
	# l                 x       'l'               insertchar  'l'
	# m                 x       'm'               insertchar  'm'
	# n                 x       'n'               insertchar  'n'
	# o                 x       'o'               insertchar  'o'
	# p                 x       'p'               insertchar  'p'
	# q                 x       'q'               insertchar  'q'
	# r                 x       'r'               insertchar  'r'
	# s                 x       's'               insertchar  's'
	# t                 x       't'               insertchar  't'
	# u                 x       'u'               insertchar  'u'
	# v                 x       'v'               insertchar  'v'
	# w                 x       'w'               insertchar  'w'
	# x                 x       'x'               insertchar  'x'
	# y                 x       'y'               insertchar  'y'
	# z                 x       'z'               insertchar  'z'
	# A                 x       'A'               insertchar  'A'
	# B                 x       'B'               insertchar  'B'
	# C                 x       'C'               insertchar  'C'
	# D                 x       'D'               insertchar  'D'
	# E                 x       'E'               insertchar  'E'
	# F                 x       'F'               insertchar  'F'
	# G                 x       'G'               insertchar  'G'
	# H                 x       'H'               insertchar  'H'
	# I                 x       'I'               insertchar  'I'
	# J                 x       'J'               insertchar  'J'
	# K                 x       'K'               insertchar  'K'
	# L                 x       'L'               insertchar  'L'
	# M                 x       'M'               insertchar  'M'
	# N                 x       'N'               insertchar  'N'
	# O                 x       'O'               insertchar  'O'
	# P                 x       'P'               insertchar  'P'
	# Q                 x       'Q'               insertchar  'Q'
	# R                 x       'R'               insertchar  'R'
	# S                 x       'S'               insertchar  'S'
	# T                 x       'T'               insertchar  'T'
	# U                 x       'U'               insertchar  'U'
	# V                 x       'V'               insertchar  'V'
	# W                 x       'W'               insertchar  'W'
	# X                 x       'X'               insertchar  'X'
	# Y                 x       'Y'               insertchar  'Y'
	# Z                 x       'Z'               insertchar  'Z'
	# 0                 x       '0'               insertchar  '0'
	# 1                 x       '1'               insertchar  '1'
	# 2                 x       '2'               insertchar  '2'
	# 3                 x       '3'               insertchar  '3'
	# 4                 x       '4'               insertchar  '4'
	# 5                 x       '5'               insertchar  '5'
	# 6                 x       '6'               insertchar  '6'
	# 7                 x       '7'               insertchar  '7'
	# 8                 x       '8'               insertchar  '8'
	# 9                 x       '9'               insertchar  '9'

	# exclamation-mark      x  '!'                insertchar  '!'
	# hash-sign             x  '\#'               insertchar  '\#'
	# dollar-sign           x  '$'                insertchar  '$'
	# percent-sign          x  '%'                insertchar  '%'
	# ampersand-sign        x  '\&'               insertchar  '\&'
	# star                  x  '\*'               insertchar  '\*'
	# plus                  x  '+'                insertchar  '+'
	# comma                 x  ','                insertchar  ','
	# dot                   x  '.'                insertchar  '.'
	# forwardslash          x  '\\'               insertchar  '\\'
	# backslash             x  '/'                insertchar  '/'
	# colon                 x  ':'                insertchar  ':'
	# semi-colon            x  '\;'               insertchar  '\;'
	# left-angle-bracket    x  '\<'               insertchar  '\<'
	# right-angle-bracket   x  '\>'               insertchar  '\>'
	# equal-sign            x  '='                insertchar  '='
	# question-mark         x  '\?'               insertchar  '\?'
	# left-square-bracket   x  '['                insertchar  '['
	# right-square-bracket  x  ']'                insertchar  ']'
	# hat-sign              x  '^'                insertchar  '^'
	# underscore            x  '_'                insertchar  '_'
	# left-brace            x  '{'                insertchar  '{'
	# right-brace           x  '\}'               insertchar  '\}'
	# left-parenthesis      x  '\('               insertchar  '\('
	# right-parenthesis     x  '\)'               insertchar  '\)'
	# pipe                  x  '\|'               insertchar  '\|'
	# tilde                 x  '\~'               insertchar  '\~'
	# at-sign               x  '@'                insertchar  '@'
	# dash                  x  '\-'               insertchar  '\-'
	# double-quote          x  '\"'               insertchar  '\"'
	# single-quote          x  "\'"               insertchar  "\'"
	# backtick              x  '\`'               insertchar  '\`'
	# whitespace            x  '\ '               insertchar  '\ '
) {
	eval "function widget::key-$keyname() {
		widget::util-$mode $widget \$@
	}"
	zle -N widget::key-$keyname
	bindkey $seq widget::key-$keyname
}

# suggested by "e.nikolov", fixes autosuggest completion being 
# overriden by keybindings: to have [zsh] autosuggest [plugin
# feature] complete visible suggestions, you can assign an array
# of shell functions to the `ZSH_AUTOSUGGEST_ACCEPT_WIDGETS` 
# variable. when these functions are triggered, they will also 
# complete any visible suggestion. Example:
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
	widget::key-right
	widget::key-shift-right
	widget::key-cmd-right
	widget::key-shift-cmd-right
)