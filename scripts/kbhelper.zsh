#* Copied from StackOverflow
#* Ref: https://stackoverflow.com/a/75102422

# zsh-shift-select https://stackoverflow.com/a/30899296
r-delregion() {
	if ((REGION_ACTIVE)) then
		zle kill-region
	else
		local widget_name=$1
		shift
		zle $widget_name -- $@
	fi
}
r-deselect() {
	((REGION_ACTIVE = 0))
	local widget_name=$1
	shift
	zle $widget_name -- $@
}
r-select() {
	((REGION_ACTIVE)) || zle set-mark-command
	local widget_name=$1
	shift
	zle $widget_name -- $@
}
for	key 	kcap	seq			mode		widget	(
	sleft	kLFT	$'\e[1;2D'	select		backward-char
	sright	kRIT	$'\e[1;2C'	select		forward-char
	sup 	kri 	$'\e[1;2A'	select		up-line-or-history
	sdown	kind	$'\e[1;2B'	select		down-line-or-history
	send	kEND	$'\E[1;2F'	select		end-of-line
	send2	x   	$'\E[4;2~'	select		end-of-line
	shome	kHOM	$'\E[1;2H'	select		beginning-of-line
	shome2	x   	$'\E[1;2~'	select		beginning-of-line
	left	kcub1	$'\EOD'		deselect	backward-char
	right	kcuf1	$'\EOC'		deselect	forward-char
	end 	kend	$'\EOF'		deselect	end-of-line
	end2	x   	$'\E4~'		deselect	end-of-line
	home	khome	$'\EOH'		deselect	beginning-of-line
	home2	x   	$'\E1~'		deselect	beginning-of-line
	csleft	x   	$'\E[1;6D'	select		backward-word
	csright	x   	$'\E[1;6C'	select		forward-word
	csend	x   	$'\E[1;6F'	select		end-of-line
	cshome	x   	$'\E[1;6H'	select		beginning-of-line
	cleft	x   	$'\E[1;5D'	deselect	backward-word
	cright	x   	$'\E[1;5C'	deselect	forward-word
	del 	kdch1	$'\E[3~'	delregion	delete-char
	bs  	x   	$'^?'		delregion	backward-delete-char
	)	{
	eval	"key-$key()	{
		r-$mode	$widget	\$@
	}"
	zle	-N	key-$key
	bindkey	${terminfo[$kcap]-$seq}	key-$key
}
# Fix zsh-autosuggestions https://stackoverflow.com/a/30899296
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
	key-right
)

function zle-clipboard-paste {
	if ((REGION_ACTIVE)); then
		zle kill-region
		wait $!
	fi
	LBUFFER+=`clippaste 2&>/dev/null`
}
zle -N zle-clipboard-paste

# ctrl+x,c,v https://unix.stackexchange.com/a/634916/424080
function zle-clipboard-cut {
	if ((REGION_ACTIVE)); then
		zle copy-region-as-kill
		print -rn -- $CUTBUFFER | clipcopy 2&>/dev/null # `clipcopy` is defined by OMZ and better than anything I could write. If not using OMZ pipe to `xsel --clipboard`
		zle kill-region
	fi
}
zle -N zle-clipboard-cut
function zle-clipboard-copy {
	if ((REGION_ACTIVE)); then
		zle copy-region-as-kill
		print -rn -- $CUTBUFFER | clipcopy 2&>/dev/null # `clipcopy` is defined by OMZ and better than anything I could write. If not using OMZ pipe to `xsel --clipboard`
	else
		zle send-break
	fi
}
zle -N zle-clipboard-copy

function zle-pre-cmd {
	stty intr "^@"
}
precmd_functions=("zle-pre-cmd" ${precmd_functions[@]})
function zle-pre-exec {
	stty intr "^C"
}
preexec_functions=("zle-pre-exec" ${preexec_functions[@]})
for key		kcap	seq			widget					arg (
	cx		_		$'^X'		zle-clipboard-cut		_
	cc		_		$'^C'		zle-clipboard-copy		_
	cv		_		$'^V'		zle-clipboard-paste		_
) {
	if [ "${arg}" = "_" ]; then
		eval "key-$key() {
			zle $widget
		}"
	else
		eval "key-$key() {
			zle-$widget $arg \$@
		}"
	fi
	zle -N key-$key
	bindkey ${terminfo[$kcap]-$seq} key-$key
}





# ctrl+a https://stackoverflow.com/a/68987551/13658418
function widget::select-all() { 
	# Use `printf` instead of `echo -n`. See: https://unix.stackexchange.com/a/653026/613660
	# Fixes bug where `wc` doesnt count escaped characters: '\e', '\x', '\0'
	local buflen=$(printf '%s' "$BUFFER" | wc -m)
	CURSOR=$buflen
	zle set-mark-command
	while [[ $CURSOR > 0 ]]; do
		zle beginning-of-line
	done
}
zle -N widget::select-all
bindkey '^a' widget::select-all

# ctrl+z
bindkey "^Z" undo

#* ////////// END REF https://stackoverflow.com/a/75102422


# https://unix.stackexchange.com/a/583783/613660, I don't know what key `5~` is supposed to represent, it just caused delay when typing the number `5`
bindkey '^H' backward-kill-word
# bindkey '5~' kill-word

# bindkey
bindkey "^U"    backward-kill-line
bindkey "^u"    backward-kill-line
bindkey "^[l"   down-case-word
bindkey "^[L"   down-case-word

# alt+<- | alt+->
bindkey "^[f" forward-word
bindkey "^[b" backward-word

# ctrl+<- | ctrl+->
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
