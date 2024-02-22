
# Might be another way to open logs than `journalctl -u ssh` but it's the one I'm familiar with. Pipe to `les>
alias sshlogs="journalctl -u ssh | ccze -m ansi | less +G" #! Requires ccze. See: https://github.com/cornet/c>
alias sshlog="sshlogs"                                          # complementary alias


#* This just adds keys that aren't already added to the ssh-agent

if [[ $SSH_CLIENT != "" ]]; then
	return
fi

# List fingerprints of already added keys
added_keys=$(ssh-add -l | awk '{print $2}')

# Add keys in ~/.ssh that aren't already added to the agent
for keyfile in ~/.ssh/id_*; do
	# Exclude public keys and known hosts
	if [[ $keyfile != *.pub ]] && [[ $keyfile != *known_hosts* ]]; then
		fingerprint=$(ssh-keygen -lf $keyfile | awk '{print $2}')
		if ! echo "$added_keys" | grep -q "$fingerprint"; then
			ssh-add "$keyfile"
		fi
	fi
done
