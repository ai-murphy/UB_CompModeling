# Exercise #1 Linux Bash Scripting Walkthrough

A complete guide to solving Linux Bash Scripting Exercise #1, with sample files, code snippets, and bash scripting tips.

---

## Overview

**Exercise #1** consists of two parts:
- **Part 1**: Create a script that swaps lines 2 and 3 for all `.swap23` files
- **Part 2**: Create an interactive script with conditional logic based on whether input is a file, directory, or new name

---

## Sample Files Reference

### .swap23 Files (3 files)

#### `data1.swap23`
**Purpose**: Test file for line swapping exercise
```
line 1: First line of data
line 2: Second line of data
line 3: Third line of data
line 4: Fourth line of data
line 5: Fifth line of data
```
**Expected output after swap23**: Lines 2 and 3 will be swapped

#### `data2.swap23`
**Purpose**: Test file with minimal content to verify swapping works on small files
```
1: One
2: Two
3: Three
```
**Expected output**: Line order becomes: 1: One, 3: Three, 2: Two

#### `records.swap23`
**Purpose**: Larger test file to ensure the script handles files with many lines
```
Header information here
Data point A
Data point B
Data point C
Data point D
Data point E
Data point F
```
**Expected output**: Header stays at line 1, "Data point B" moves to line 2, "Data point A" moves to line 3

---

### Python Files with "import" (3 files)

#### `module1.py`
**Count of "import" word: 3 times**
```python
import os
import sys
import json

def hello():
    print('Hello World')

if __name__ == '__main__':
    hello()
```

#### `module2.py`
**Count of "import" word: 3 times**
```python
from pathlib import Path
import pandas as pd
import numpy as np

def process_data():
    pass
```

#### `utilities.py`
**Count of "import" word: 3 times**
```python
import argparse
import re
import urllib.request

class Processor:
    def run(self):
        pass
```

---

### Python Files without "import" (2 files)

#### `simple.py`
**Count of "import" word: 0 times**
```python
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b
```

#### `config.py`
**Count of "import" word: 0 times**
```python
# Configuration file
DATABASE_URL = 'localhost:5432'
DEBUG_MODE = True
TIMEOUT = 30
```

---

### Other Files (3 files - for filtering practice)

#### `readme.txt`
Used to verify that only `.swap23` files are processed

#### `config.ini`
Used to verify that only `.py` files are analyzed for "import"

#### `data.csv`
Used to verify proper file extension filtering

---

## Part 1: Swap Lines 2 and 3 in .swap23 Files

### Step-by-Step Breakdown

#### Key Bash Concepts

**1. File Globbing with Wildcards**
- `*.swap23` matches all files ending in `.swap23`
- This pattern automatically finds all files without explicitly listing them

**2. Reading File Lines**
```bash
head -n 1 file.txt    # Get first line
head -n 2 file.txt    # Get first two lines
tail -n +3 file.txt   # Get lines starting from line 3 onward
```

**3. Temporary Files**
- Always use temporary files when modifying content to avoid data loss
- Use `mv` to atomically replace the original file

**4. Command Substitution**
- `$()` syntax captures command output for use in variables
- More modern than backticks `` ` ` ``

#### Complete Solution for Part 1

```bash
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
    
    # Check if file has at least 3 lines - but fails if there's 
    # exactly 3 lines with no carriage return at the end of line 3
    line_count=$(wc -l < "$file")
    # Better implementation
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
```

#### Alternative Solution Using awk (More Elegant)

```bash
#!/bin/bash

# More elegant solution using awk
for file in *.swap23; do
    if [ ! -f "$file" ]; then
        continue
    fi
    
    # Use awk to swap lines 2 and 3
    awk '
        NR==1 { print; next }      # Print line 1 as-is
        NR==2 { line2=$0; next }   # Store line 2, don't print yet
        NR==3 { print; next }      # Print line 3 (now it's in position 2)
        NR==4 { print line2; print } # Print stored line 2, then line 4
        NR>4  { print }            # Print remaining lines
    ' "$file" > "${file}.tmp"
    
    mv "${file}.tmp" "$file"
    echo "Processed: $file"
done
```

#### Solution Using sed (One-Liner Alternative)

```bash
#!/bin/bash

# Compact solution using sed
for file in *.swap23; do
    [ -f "$file" ] && sed -i '2,3s/^\(.*\)$/@\1/; T; h; $!d; x; s/@//g; G' "$file" 2>/dev/null || {
        # Fallback for older sed versions without -i
        sed '2,3s/^\(.*\)$/@\1/; T; h; $!d; x; s/@//g; G' "$file" > "${file}.tmp"
        mv "${file}.tmp" "$file"
    }
done
```

**Note**: The sed approach is less readable. The awk solution provides better performance and clarity.

---

## Part 2: Interactive File Analysis Script

### Step-by-Step Breakdown

#### Key Bash Concepts

**1. User Input**
```bash
read -p "Prompt text: " variable_name
```

**2. File System Tests**
- `-f` : Test if file exists
- `-d` : Test if directory exists
- `-e` : Test if path exists (file or directory)

**3. Line Counting**
```bash
wc -l < file.txt      # Count lines (cleanest method)
cat file.txt | wc -l  # Also works but spawns extra process
```

**4. Copying Files with Wildcards**
```bash
cp *.f90 destination_dir/   # Copy all .f90 files to directory
```

**5. Searching and Counting Word Occurrences**
```bash
grep -c "import" file.py       # Count lines containing "import"
grep -o "import" file.py | wc -l  # Count total occurrences
```

**6. Writing to Files**
```bash
echo "content" >> file.txt     # Append to file
echo "content" > file.txt      # Overwrite file
```

#### Complete Solution for Part 2

```bash
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
```

#### Improved Version with Better Error Handling

```bash
#!/bin/bash

# Enhanced version of script 2 with additional checks

read -p "Enter file or directory name: " input_name

# Validate input is not empty
if [ -z "$input_name" ]; then
    echo "Error: Input cannot be empty"
    exit 1
fi

# Case 1: Input is an existing file
if [ -f "$input_name" ]; then
    if [ -r "$input_name" ]; then
        line_count=$(wc -l < "$input_name")
        echo "Number of lines in '$input_name': $line_count"
    else
        echo "Error: Cannot read file '$input_name'"
        exit 1
    fi

# Case 2: Input is an existing directory
elif [ -d "$input_name" ]; then
    if [ -w "$input_name" ]; then
        echo "Processing directory: $input_name"
        
        # Count .f90 files before copying
        f90_count=$(ls *.f90 2>/dev/null | wc -l)
        
        if [ "$f90_count" -gt 0 ]; then
            cp *.f90 "$input_name/" 2>/dev/null
            echo "Successfully copied $f90_count .f90 file(s) to '$input_name/'"
        else
            echo "No .f90 files found in current directory"
        fi
    else
        echo "Error: No write permission for directory '$input_name'"
        exit 1
    fi

# Case 3: Input is neither file nor directory (new name)
else
    echo "Creating new file: $input_name"
    
    # Initialize output file
    output_file="$input_name"
    
    # Check if file already exists
    if [ -f "$output_file" ]; then
        read -p "File exists. Overwrite? (y/n): " confirm
        if [ "$confirm" != "y" ]; then
            echo "Cancelled"
            exit 0
        fi
    fi
    
    # Create the output file
    {
        # Find all .py files and process them
        found_any=false
        for pyfile in *.py; do
            if [ ! -f "$pyfile" ]; then
                continue
            fi
            
            found_any=true
            
            # Count occurrences of "import" (whole word)
            import_count=$(grep -o "\bimport\b" "$pyfile" | wc -l)
            
            # Write filename and count
            echo "$pyfile: $import_count"
        done
        
        # If no .py files found
        if [ "$found_any" = false ]; then
            echo "# No .py files found in current directory"
        fi
    } > "$output_file"
    
    echo "File created successfully: $output_file"
    echo ""
    echo "=== Content Preview ==="
    cat "$output_file"
fi
```

---

## Part 3: Complete Combined Script

### Full Solution Script (Both Parts)

```bash
#!/bin/bash

# Exercise #1 Complete Solution
# Parts 1 and 2 combined in one script
# Usage: ./solution.sh

# ============================================================
# PART 1: Swap lines 2 and 3 in all .swap23 files
# ============================================================

echo "=== Part 1: Processing .swap23 files ==="
echo ""

processed_count=0

for file in *.swap23; do
    # Skip if no .swap23 files exist
    if [ ! -f "$file" ]; then
        continue
    fi
    
    # Check if file has at least 3 lines
    line_count=$(wc -l < "$file")
    if [ "$line_count" -lt 3 ]; then
        echo "Warning: $file has only $line_count lines (need at least 3), skipping..."
        continue
    fi
    
    # Create temporary file
    temp_file="${file}.tmp.$$"
    
    # Extract lines using sed for robustness
    line1=$(sed -n '1p' "$file")
    line2=$(sed -n '2p' "$file")
    line3=$(sed -n '3p' "$file")
    
    # Write to temporary file (header, swapped lines 2&3, rest of file)
    {
        echo "$line1"
        echo "$line3"
        echo "$line2"
        tail -n +4 "$file"
    } > "$temp_file"
    
    # Replace original file
    mv "$temp_file" "$file"
    processed_count=$((processed_count + 1))
    echo "✓ Processed: $file (swapped lines 2 and 3)"
done

if [ $processed_count -eq 0 ]; then
    echo "No .swap23 files found in current directory"
fi

echo ""
echo "Part 1 Complete! Processed $processed_count files."
echo ""
echo "============================================================"
echo ""

# ============================================================
# PART 2: Interactive file analysis
# ============================================================

echo "=== Part 2: Interactive File Analysis ==="
echo ""

read -p "Enter file or directory name: " input_name

# Validate input
if [ -z "$input_name" ]; then
    echo "Error: Input cannot be empty"
    exit 1
fi

# CASE 1: Existing file
if [ -f "$input_name" ]; then
    if [ -r "$input_name" ]; then
        line_count=$(wc -l < "$input_name")
        echo "File: $input_name"
        echo "Number of lines: $line_count"
    else
        echo "Error: Cannot read file '$input_name'"
        exit 1
    fi

# CASE 2: Existing directory
elif [ -d "$input_name" ]; then
    if [ -w "$input_name" ]; then
        echo "Detected: Directory '$input_name'"
        
        # Count .f90 files
        f90_count=0
        for f90file in *.f90; do
            if [ -f "$f90file" ]; then
                f90_count=$((f90_count + 1))
            fi
        done
        
        if [ $f90_count -gt 0 ]; then
            cp *.f90 "$input_name/" 2>/dev/null
            echo "Success: Copied $f90_count .f90 file(s) to '$input_name/'"
        else
            echo "Info: No .f90 files found in current directory"
        fi
    else
        echo "Error: No write permission for '$input_name'"
        exit 1
    fi

# CASE 3: New file (neither existing file nor directory)
else
    echo "Creating new file: $input_name"
    echo ""
    
    output_file="$input_name"
    
    # Check if file exists
    if [ -f "$output_file" ]; then
        read -p "File already exists. Overwrite? (y/n): " confirm
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            echo "Cancelled. File not overwritten."
            exit 0
        fi
    fi
    
    # Generate file with .py files and import counts
    {
        found_any=false
        for pyfile in *.py; do
            if [ ! -f "$pyfile" ]; then
                continue
            fi
            
            found_any=true
            
            # Count "import" word occurrences
            # Using \b for word boundaries (whole word only)
            import_count=$(grep -o "\bimport\b" "$pyfile" 2>/dev/null | wc -l)
            
            echo "$pyfile: $import_count"
        done
        
        if [ "$found_any" = false ]; then
            echo "# No .py files found in current directory"
        fi
    } > "$output_file"
    
    echo "File created: $output_file"
    echo ""
    echo "=== File Contents ==="
    cat "$output_file"
fi

echo ""
echo "=== Exercise Complete ==="
```

---

## Bash Scripting Tips & Tricks

### 1. **Globbing and Pattern Matching**
```bash
# Safe globbing in loops
for file in *.txt; do
    [ -f "$file" ] || continue  # Skip if no files match
done

# Or use nullglob
shopt -s nullglob
for file in *.txt; do
    # Safe: loop won't execute if no files match
done
shopt -u nullglob
```

### 2. **Preventing Word Splitting**
```bash
# WRONG: Spaces in filenames break this
for file in *.txt; do
    wc -l $file  # Fails with spaces in filename!
done

# CORRECT: Always quote variables
for file in *.txt; do
    wc -l "$file"  # Safe, handles all filenames
done
```

### 3. **Checking Command Success**
```bash
# Method 1: Check exit status explicitly
if cp file1.txt file2.txt; then
    echo "Copy successful"
else
    echo "Copy failed"
fi

# Method 2: Using || and &&
cp file1.txt file2.txt && echo "Success" || echo "Failed"
```

### 4. **Safe Temporary Files**
```bash
# UNSAFE: Vulnerable to race conditions
temp_file="/tmp/myfile.tmp"

# SAFE: Use mktemp
temp_file=$(mktemp)
# Use temp_file
rm "$temp_file"

# Or with suffix
temp_file=$(mktemp --suffix=.tmp)
```

### 5. **Word Boundaries in grep**
```bash
# Matches "import" anywhere
grep "import" file.py

# Matches "import" as whole word only
grep "\bimport\b" file.py

# Or use -w flag
grep -w "import" file.py
```

### 6. **Counting Occurrences**
```bash
# Count lines containing pattern
grep -c "import" file.py  # Output: 3 (three lines)

# Count total pattern occurrences
grep -o "import" file.py | wc -l  # Output: 3 (three times)

# Difference matters for multiple occurrences per line!
```

### 7. **Process Substitution**
```bash
# Read multiple files into variables
line1=$(head -n 1 file.txt)
line2=$(sed -n '2p' file.txt)
line3=$(tail -n 1 file.txt)
```

### 8. **Atomic File Replacement**
```bash
# Create new content safely, then replace
# This prevents data loss if something goes wrong
echo "new content" > temp.txt
mv temp.txt original.txt  # Atomic operation
```

### 9. **Debugging Scripts**
```bash
# Run with debug mode
bash -x script.sh

# Or at the top of script
set -x  # Enable debug
set +x  # Disable debug

# Strict mode (fail on errors, undefined variables)
set -euo pipefail
```

### 10. **Reading File Content Efficiently**
```bash
# Less efficient: spawns wc process
lines=$(cat file.txt | wc -l)

# More efficient: built-in
lines=$(wc -l < file.txt)

# Most efficient for single line
IFS= read -r first_line < file.txt
```

---

## Testing the Complete Solution

### Step 1: Prepare Environment
```bash
# Create a working directory
mkdir exercise1_test
cd exercise1_test

# Copy the sample files here (created earlier)
cp /path/to/sample/files/* .

# Or create them manually:
# .swap23 files: data1.swap23, data2.swap23, records.swap23
# .py with import: module1.py, module2.py, utilities.py
# .py without import: simple.py, config.py
# Other: readme.txt, config.ini, data.csv
```

### Step 2: Run Part 1
```bash
# Create the script
cat > part31.sh << 'EOF'
#!/bin/bash
for file in *.swap23; do
    [ -f "$file" ] || continue
    line_count=$(wc -l < "$file")
    [ "$line_count" -lt 3 ] && continue
    temp="${file}.tmp"
    {
        sed -n '1p' "$file"
        sed -n '3p' "$file"
        sed -n '2p' "$file"
        tail -n +4 "$file"
    } > "$temp"
    mv "$temp" "$file"
    echo "✓ $file"
done
EOF

chmod +x part31.sh
./part31.sh

# Verify results
echo "=== Before and After ==="
cat data1.swap23  # Should show line 3 then line 2
```

### Step 3: Run Part 2
```bash
# Test Case 1: Existing file
./part32.sh
# Enter: data1.swap23
# Expected: "Number of lines in data1.swap23: 5"

# Test Case 2: Existing directory
mkdir test_dir
./part32.sh
# Enter: test_dir
# Expected: Copies all .f90 files (if any exist)

# Test Case 3: New file name
./part32.sh
# Enter: import_report.txt
# Expected: Creates file with Python files and import counts
```

---

## Common Errors and Solutions

### Error 1: "command not found" for sed/awk
```bash
# Solution: sed and awk should be standard on all Linux systems
# If missing: sudo apt-get install sed gawk (Debian/Ubuntu)
```

### Error 2: "No such file or directory" with wildcards
```bash
# Problem: *.swap23 doesn't expand if no files exist
# Solution: Always check with [ -f "$file" ]

for file in *.swap23; do
    [ -f "$file" ] || continue
    # Process file
done
```

### Error 3: Spaces in filenames break the script
```bash
# Problem: for file in *.txt causes issues with spaces
# Solution: Always quote variables: "$file"
```

### Error 4: grep returns different counts than expected
```bash
# Problem: grep -c counts lines, not occurrences
# Solution: Use grep -o | wc -l for total count

# Count lines with "import": grep -c "import" file.py → 3
# Count "import" occurrences: grep -o "import" file.py | wc -l → 3
```

---

## Summary Checklist

- ✅ Part 1: Script that swaps lines 2 and 3 in all `.swap23` files
- ✅ Part 2: Interactive script that:
  - Displays line count for existing files
  - Copies `.f90` files to existing directories
  - Creates new file with `.py` filenames and import counts
- ✅ Proper file globbing with safety checks
- ✅ Atomic file operations using temp files
- ✅ Proper quoting to handle filenames with spaces
- ✅ Word boundary checking in grep
- ✅ Error handling and validation

---

## References

- Bash Manual: Parameter Expansion and Globbing
- sed and awk documentation
- grep options: `-o`, `-w`, `-c`, `--color`
- Temporary file safety with mktemp

