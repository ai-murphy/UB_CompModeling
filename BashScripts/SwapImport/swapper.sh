#!/bin/bash

# Script to swap lines 2 and 3 in all .swap23 files
# Author: Solution
# Date: 2025

# Loop through all files with .swap23 extension
for file in *.swap23; do
    # Check if file exists (in case no .swap23 files found)
    if [ ! -f "$file" ]; then
        continue
    fi
    
    # Check if file has at least 3 lines
    #line_count=$(wc -l < "$file")
    line_count=$(grep -c '^' < "$file")
    if [ "$line_count" -lt 3 ]; then
        echo "Warning: $file has less than 3 lines, skipping..."
        continue
    fi
    
    # Create temporary file
    temp_file="${file}.tmp"
    
    # Extract the parts:
    # Line 1
    line1=$(sed -n '1p' "$file")
    # Line 2 (will become line 3)
    line2=$(sed -n '2p' "$file")
    # Line 3 (will become line 2)
    line3=$(sed -n '3p' "$file")
    # All remaining lines (line 4 onwards)
    remaining=$(tail -n +4 "$file")
    
    # Write swapped content to temporary file
    {
        echo "$line1"
        echo "$line3"
        echo "$line2"
        if [ -n "$remaining" ]; then
            echo "$remaining"
        fi
    } > "$temp_file"
    
    # Replace original with modified version
    mv "$temp_file" "$file"
    
    echo "Swapped lines 2 and 3 in: $file"
done

echo "Done!"