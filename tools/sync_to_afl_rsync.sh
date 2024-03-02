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

# TODO: change name for afl id:0000xxx
exit -1

while true; do
    rsync -avPuz ${LOCAL_DIR} ${SSH_SERVER}:${REMOTE_DIR}
    echo "[*] Round complete. Waiting for 600 seconds."
    sleep 600
done
