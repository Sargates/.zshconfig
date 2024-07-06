#!/bin/zsh

if (( ! ${+commands[tailscale]} )); then # Return of tailscale is not installed
	return
fi

#? Meant for toggling connection automatically, haven't gotten this working yet as I can't figure out how to tell if TS is up or down in a simple way
# tts() {
# 	local output="$(tailscale ping 127.0.0.1)"

# 	if [[ $output = "Tailscale is stopped." ]]; then # connect to tailscale
# 		sudo tailscale up --accept-routes --exit-node "home-network"
# 	else # disconnect from tailscale
# 		sudo tailscale down
# 	fi
# }

alias tscon="sudo tailscale up --accept-routes --exit-node "home-network""
alias tsdc="sudo tailscale down"