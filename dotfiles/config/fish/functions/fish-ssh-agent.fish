function fish-ssh-agent --description 'start ssh-agent in fish shell'
    eval (ssh-agent -c)
    set -x SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -x SSH_AGENT_PID $SSH_AGENT_PID
end
