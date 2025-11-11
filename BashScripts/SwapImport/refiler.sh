#!/bin/bash

# Script 2: Interactive file analysis
# Asks for input and performs different actions based on type

read -p "Enter file or directory name: " input_name

# Case 1: Input is an existing file
if [ -f "$input_name" ]; then
    line_count=$(wc -l < "$input_name")
    echo "Number of lines in $input_name: $line_count"

# Case 2: Input is an existing directory
elif [ -d "$input_name" ]; then
    echo "Found directory: $input_name"
    
    # Check if any .f90 files exist in current directory
    if ls *.f90 1>/dev/null 2>&1; then
        cp *.f90 "$input_name/"
        echo "Copied all .f90 files to $input_name/"
    else
        echo "No .f90 files found in current directory"
    fi

# Case 3: Input is neither file nor directory (new name)
else
    echo "Creating new file: $input_name"
    
    # Create file with Python files and import counts
    {
        echo "# Python Files and Import Counts"
        echo "# Generated on: $(date)"
        echo ""
        
        # Find all .py files in current directory
        for pyfile in *.py; do
            # Check if any .py files exist
            if [ ! -f "$pyfile" ]; then
                continue
            fi
            
            # Count occurrences of the word "import" using grep
            import_count=$(grep -o "import" "$pyfile" | wc -l)
            
            # Output filename and count
            echo "$pyfile: $import_count"
        done
    } > "$input_name"
    
    echo "File created: $input_name"
    echo "Contents:"
    cat "$input_name"
fi