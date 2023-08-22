
alias addssh='ssh-add ~/.ssh/id_rsa'

# ssh-agent configuration
if [ -z "$(pgrep ssh-agent)" ]; then
    eval $(ssh-agent -s) > /dev/null
	ssh-add ~/.ssh/id_rsa
else
    export SSH_AGENT_PID=$(pgrep ssh-agent)
    export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name "agent.*")
fi