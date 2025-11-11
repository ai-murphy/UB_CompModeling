#!/bin/bash

read -p "Enter first filename: " file1
read -p "Enter second filename: " file2

# Get file sizes using wc (count bytes)
size1=$(wc -c < "$file1")
size2=$(wc -c < "$file2")

echo "File sizes:"
echo "  $file1: $size1 bytes"
echo "  $file2: $size2 bytes"

# Compare and display larger file
if [ "$size1" -gt "$size2" ]; then
    echo "Larger file: $file1"
else
    echo "Larger file: $file2"
fi