#!/bin/bash

# Your Git repository path
REPO_DIR="/mnt/c/Users/PR40098698/Desktop/dockerTutorial"

# File to track last pushed script
STATE_FILE="$REPO_DIR/.last_pushed"

# Go to repository
cd "$REPO_DIR" || exit 1

# Get all .sh files except auto_push.sh
FILES=($(find . -maxdepth 1 -name "*" ! -name "auto_push.sh" | sort))

# Create state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "-1" > "$STATE_FILE"
fi

# Read last pushed index
LAST=$(cat "$STATE_FILE")
NEXT=$((LAST + 1))

# Check if all files are already pushed
if [ "$NEXT" -ge "${#FILES[@]}" ]; then
    echo "All script files have already been pushed."
    exit 0
fi

# Select next file
FILE="${FILES[$NEXT]}"

echo "Pushing file: $FILE"

# Git operations
git add "$FILE"

git commit -m "Add $(basename "$FILE")"

git push origin master

# Save current index
echo "$NEXT" > "$STATE_FILE"

echo "Successfully pushed: $FILE"
