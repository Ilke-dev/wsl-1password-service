#!/bin/bash

# Configure ssh forwarding
export SSH_AUTH_SOCK=$HOME/.1password/agent.sock
export OP_BIOMETRIC_UNLOCK_ENABLED=true
export PATH="${PATH}:${NPIPE_RELAY_EXE}"

# Kill any previous socat instance
pkill socat

ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
if [[ $ALREADY_RUNNING != "0" ]]; then
    if [[ -S $SSH_AUTH_SOCK ]]; then
        echo "Removing previous socket..."
        rm "$SSH_AUTH_SOCK"
    fi
    echo "Starting SSH-Agent relay..."
    # Use exec to run socat in the foreground so systemd can track it
    exec setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork
fi

exit 0