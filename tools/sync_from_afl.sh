#!/bin/bash

# Check if four arguments are provided
if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
    echo "Usage: $0 <ssh_server> <remote_directory> <local_directory> [suffix]"
    exit 1
fi

# Assign the command line arguments to variables
SSH_SERVER="$1"
REMOTE_DIR="$2"
LOCAL_DIR="$3"
SUFFIX="${4:-}"

# Function to perform the SCP operation for specific files in alphabetical order
function perform_scp {
    # Get a list of files from the remote directory excluding .json and .track files
    IFS=$'\n' read -r -d '' -a remote_files < <(ssh "${SSH_SERVER}" "find ${REMOTE_DIR} -maxdepth 1 -type f -name 'id:*' ! -name '*.json' ! -name '*.track'" && printf '\0')

    # Sort the files alphabetically
    IFS=$'\n' sorted_files=($(sort <<<"${remote_files[*]}"))
    unset IFS

    # Loop through each sorted remote file and copy if it doesn't exist locally
    for remote_file in "${sorted_files[@]}"; do
        base_name=$(basename "${remote_file}")
        if [ -n "${SUFFIX}" ]; then
            # local_file="${LOCAL_DIR}/${base_name%.*}${SUFFIX}.${base_name##*.}"
		    local_file="${LOCAL_DIR}/${base_name}.${SUFFIX}"
        else
            local_file="${LOCAL_DIR}/${base_name}"
        fi

        if [ ! -f "${local_file}" ]; then
            # File does not exist locally, copy it
            scp "${SSH_SERVER}:${remote_file}" "${local_file}"
        fi
    done
}

# Perform the SCP operation
while true; do
    perform_scp
    sleep 300
done
