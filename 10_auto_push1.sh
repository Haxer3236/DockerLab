#!/bin/bash

# Your Git repository path
REPO_DIR="/mnt/c/Users/PR40098698/Desktop/dockerTutorial"

# File to track last pushed script
STATE_FILE="$REPO_DIR/.last_pushed"

# Go to repository
cd "$REPO_DIR" || exit 1

# Get all normal files except hidden files and auto_push.sh
FILES=($(find . -maxdepth 1 -type f ! -name ".*" ! -name "auto_push.sh" | sort))

# Create state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "-1" > "$STATE_FILE"
fi

# Read last pushed index
LAST=$(cat "$STATE_FILE")
NEXT=$((LAST + 1))

# Check if all files are already pushed
if [ "$NEXT" -ge "${#FILES[@]}" ]; then
    echo "All files have already been processed."
    exit 0
fi

# Select next file
FILE="${FILES[$NEXT]}"

echo "Processing file: $FILE"

# Check whether file has changes or is untracked
git status --porcelain "$FILE" | grep -q .

if [ $? -ne 0 ]; then
    echo "No changes found in $FILE"

    # Move to next file for next run
    echo "$NEXT" > "$STATE_FILE"
    exit 0
fi

# Stage only selected file
git add "$FILE"

# Commit only if staged content exists
git diff --cached --quiet

if [ $? -eq 0 ]; then
    echo "Nothing to commit for $FILE"

    echo "$NEXT" > "$STATE_FILE"
    exit 0
fi

git commit -m "Add $(basename "$FILE")"
git push origin master

# Save current index
echo "$NEXT" > "$STATE_FILE"

echo "Successfully pushed: $FILE"
echo "<----------------------------------------------------------------------------->"
