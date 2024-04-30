
# Might be another way to open logs than `journalctl -u ssh` but it's the one I'm familiar with. Pipe to `les>
alias sshlogs="journalctl -u ssh -n 400 | ccze -m ansi | less +G" #! Requires ccze. See: https://github.com/cornet/ccze
alias sshlog="sshlogs"                                     # auto correct


#* This just adds keys that aren't already added to the ssh-agent

if [[ $SSH_CLIENT != "" ]]; then
	export DISPLAY=":0" #* `clipcopy` doesn't get defined by OMZ if `$DISPLAY` is empty (ex.: a ssh session), this forces OMZ
	#* via `kbhelper.zsh` to work over ssh. Copying only works in the current SSH session, doesn't copy to host clipboard
	return
fi

# List fingerprints of already added keys
added_keys=$(ssh-add -l | awk '{print $2}')

# Add keys in ~/.ssh/ that aren't already added to the agent
for keyfile in ~/.ssh/id_*; do
	# Exclude public keys and known hosts
	if [[ $keyfile != *.pub ]] && [[ $keyfile != *known_hosts* ]]; then
		fingerprint=$(ssh-keygen -lf $keyfile | awk '{print $2}')
		if ! echo "$added_keys" | grep -q "$fingerprint"; then
			ssh-add "$keyfile"
		fi
	fi
done
