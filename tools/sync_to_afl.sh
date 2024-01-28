#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <local_directory> <remote_user@remote_host:remote_directory>"
    exit 1
fi

local_path=$1
remote_path=$2

# Split the remote path into user@host and directory
IFS=':' read -r remote_userhost remote_dir <<< "$remote_path"

# Repeat the operation every 300 seconds
while true; do
    # Iterate over all files in the directory matching the pattern sample_*, sorted alphabetically
    files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$local_path" -type f -name "sample_*" -print0 | sort -z)

    for file in "${files[@]}"; do
        # Extract the 5-digit ID from the filename
        filename=$(basename -- "$file")
        echo $filename
        file_id_5digit=${filename#"sample_"}  # Remove 'sample_' prefix

        # Format the ID into 6 digits
        file_id_decimal=$(echo $file_id_5digit | sed 's/^0*//')  # Remove leading zeros
        file_id_6digit=$(printf "%06d" "$file_id_decimal")

        # Check if a file with this 6-digit ID already exists in the remote directory
        if ssh "$remote_userhost" test -e "${remote_dir}/id:${file_id_6digit}"; then
            echo "File with ID ${file_id_6digit} already exists on the remote server. Skipping."
            continue
        fi

        # SCP the file to the remote location with the new 6-digit ID
        echo scp "$file" "${remote_userhost}:${remote_dir}/id:${file_id_6digit}"
        scp "$file" "${remote_userhost}:${remote_dir}/id:${file_id_6digit}"

    done

    echo "Round complete. Waiting for 300 seconds."
    sleep 300
done

echo "Transfer complete."
