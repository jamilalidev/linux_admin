#!/bin/bash
# Source directories to backup (separated by spaces)
SOURCE_DIRS="/home/parallels/Downloads  /home/parallels/Music"

# Destination directory for the backup
DEST_DIR="/home/parallels/recovery"

# Maximum number of backup files to keep
MAX_BACKUP_COUNT=5

# Create a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

# Create the backup filename with timestamp
BACKUP_FILE="${DEST_DIR}/backup_${TIMESTAMP}.tar.gz"

# Function to perform the backup
perform_backup() {
    # Compress the source directories into a single archive file
    tar -czf "${BACKUP_FILE}" ${SOURCE_DIRS}
    
    echo "Backup created: ${BACKUP_FILE}"
}

# Function to rotate backups and limit the number of backup files
rotate_backups() {
    # Get the list of backup files in the destination directory
    backup_files=( "${DEST_DIR}/backup_"*.tar.gz )
    
    # Sort the backup files by modification time (oldest first)
    sorted_backup_files=( $(printf '%s\n' "${backup_files[@]}" | sort) )
    
    # Calculate the number of excess backup files
    excess_count=$(( ${#sorted_backup_files[@]} - MAX_BACKUP_COUNT ))
    
    if [ ${excess_count} -gt 0 ]; then
        # Remove the oldest backup files exceeding the limit
        files_to_remove=( "${sorted_backup_files[@]:0:${excess_count}}" )
        rm -f "${files_to_remove[@]}"
        
        echo "Removed ${excess_count} backup(s)."
    else
        echo "No backups to remove."
    fi
}

# Perform the backup
perform_backup

# Rotate backups and limit the number of backup files
rotate_backups
