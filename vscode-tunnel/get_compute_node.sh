#!/bin/bash

SESSION_NAME="vscode"

function get_hostname() {
    tmux send-keys -t $SESSION_NAME hostname ENTER
    sleep 1
    NODE=$(tmux capture-pane -t $SESSION_NAME -p | sed '/^$/d' | tail -n 2 | head -n 1)
    
    echo "$NODE"  # Return value using echo, not return
}

tmux new -A -d -s $SESSION_NAME

# Capture the function output correctly
#NODE=$(get_hostname)
NODE=$HOSTNAME

if [[ "$NODE" =~ "login" ]]; then
    tmux send-keys -t $SESSION_NAME vscodejob ENTER
    sleep 5
    NODE=$(get_hostname)  # Capture output again
else
    :  # No-op
fi

echo "$NODE"
exit 0
