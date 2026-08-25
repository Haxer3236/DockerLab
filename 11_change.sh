#/bin/bash
for file in *; do
    [ -f "$file" ] && echo "" >> "$file"
done

