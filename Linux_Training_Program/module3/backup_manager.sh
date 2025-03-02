#!/bin/bash

# Ensure correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source_directory> <backup_directory> <file_extension>"
    exit 1
fi

SRC_DIR="$1"
BACKUP_DIR="$2"
EXT="$3"

# Validate source directory
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Source directory does not exist."
    exit 1
fi

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR" || { echo "Error: Failed to create backup directory."; exit 1; }
fi

# Find files matching the extension
FILES=($SRC_DIR/*$EXT)

# Check if files exist
if [ "${#FILES[@]}" -eq 0 ] || [ "${FILES[0]}" = "$SRC_DIR/*$EXT" ]; then
    echo "No files matching extension '$EXT' found in $SRC_DIR."
    exit 0
fi

# Backup process
BACKUP_COUNT=0
TOTAL_SIZE=0
export BACKUP_COUNT

for FILE in "${FILES[@]}"; do
    FILENAME=$(basename "$FILE")
    DEST_FILE="$BACKUP_DIR/$FILENAME"
    FILE_SIZE=$(stat -c%s "$FILE")
    echo "Backing up: $FILENAME ($FILE_SIZE bytes)"
    
    if [ -f "$DEST_FILE" ]; then
        if [ "$FILE" -nt "$DEST_FILE" ]; then
            cp "$FILE" "$DEST_FILE"
        fi
    else
        cp "$FILE" "$DEST_FILE"
    fi

    TOTAL_SIZE=$((TOTAL_SIZE + FILE_SIZE))
    ((BACKUP_COUNT++))

done

# Generate report
REPORT_FILE="$BACKUP_DIR/backup_report.log"
echo "Backup Summary:" > "$REPORT_FILE"
echo "Total files backed up: $BACKUP_COUNT" >> "$REPORT_FILE"
echo "Total size: $TOTAL_SIZE bytes" >> "$REPORT_FILE"
echo "Backup location: $BACKUP_DIR" >> "$REPORT_FILE"
echo "Backup completed successfully. Report saved at $REPORT_FILE"
