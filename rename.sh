#!/bin/bash

i=1

for f in *; do
    if [ -f "$f" ] && [ "$f" != "rename.sh" ]; then
        new_name=$(printf "%02d_%s" "$i" "$f")

        echo "Renaming: $f -> $new_name"

        mv "$f" "$new_name"

        ((i++))
    fi
done

echo "✅ File renaming completed."
`
