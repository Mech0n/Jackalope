#!/bin/bash

# Check if four arguments are provided
if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
    echo "Usage: $0 <ssh_server> <remote_directory> <local_directory> [suffix]"
    exit 1
fi

# Assign the command line arguments to variables and ensure directories end with "/"
SSH_SERVER="$1"
REMOTE_DIR="${2%/}/"
LOCAL_DIR="${3%/}/"
SUFFIX="${4:-}"

while true; do
    rsync -avPuz --exclude '*.json*' ${SSH_SERVER}:${REMOTE_DIR} ${LOCAL_DIR}
    echo "[*] Round complete. Waiting for 600 seconds."
    sleep 600
done
