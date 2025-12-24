#!/bin/bash

PROJECT_PATH=$1
SYNC_CONFIG=".sync-folders"

if [ -z "$PROJECT_PATH" ]; then
    echo "Usage: $0 <project_path>"
    exit 1
fi

if [ ! -f "$SYNC_CONFIG" ]; then
    echo "Error: $SYNC_CONFIG not found"
    exit 1
fi

# Collect all changes from dry-run across all sync folders
echo "Checking what will be pulled from vacc:$PROJECT_PATH/..."
ALL_CHANGES=""

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Run dry-run for this subfolder (with --delete to show what would be removed)
    CHANGES=$(rsync -avn --itemize-changes --delete vacc:$PROJECT_PATH/$line ./$PROJECT_PATH/$line 2>/dev/null | grep -v '/$')

    if [ -n "$CHANGES" ]; then
        ALL_CHANGES="${ALL_CHANGES}${CHANGES}\n"
    fi
done < "$SYNC_CONFIG"

if [ -z "$ALL_CHANGES" ]; then
    echo "No changes to pull. Already up to date."
    exit 0
fi

echo "The following files will be affected:"
echo -e "$ALL_CHANGES"
echo ""
echo "Options:"
echo "  y - Continue with deletions"
echo "  s - Skip deletions (sync only)"
echo "  n - Cancel"
read -p "Choose (y/s/n): " -n 1 -r
echo ""

DELETE_FLAG=""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    DELETE_FLAG="--delete"
    echo "Proceeding with deletions..."
elif [[ $REPLY =~ ^[Ss]$ ]]; then
    echo "Proceeding without deletions..."
else
    echo "Pull cancelled."
    exit 0
fi

# Perform the actual sync for each folder
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    echo "Syncing: $line"
    rsync -avP $DELETE_FLAG vacc:$PROJECT_PATH/$line ./$PROJECT_PATH/$line
done < "$SYNC_CONFIG"

echo "Pull complete!"

