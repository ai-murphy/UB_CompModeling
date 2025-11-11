# Linux Bash Scripting - Complete Walkthrough

## Table of Contents
1. [Overview](#overview)
2. [Exercise 1: Finding Lines with Specific Patterns](#exercise-1-finding-lines-with-specific-patterns)
3. [Exercise 2: File Size Comparison](#exercise-2-file-size-comparison)
4. [Sample Files Reference](#sample-files-reference)
5. [Bash Scripting Tips and Tricks](#bash-scripting-tips-and-tricks)
6. [Quick Reference Guide](#quick-reference-guide)

---

## Overview
This exercise focuses on two key Linux bash scripting tasks:
- **1**: Pattern matching and filtering text
- **2**: File operations and size comparison

### Skills Covered
- Text processing tools: grep, awk, sed
- File operations: stat, ls, wc, du
- Bash control structures: if, test operators
- String manipulation and variables
- Command-line input handling

---

## Exercise 1: Finding Lines with Specific Patterns

### Problem Statement
Write a **one-line command** that identifies all lines in a file called `program.f90` that:
- Contain the `x_pos` variable
- Do NOT contain the `y_pos` variable

### Solution 1: grep with pipe (RECOMMENDED)

```bash
grep 'x_pos' ./program.f90
grep 'x_pos' ./program.f90 | wc -l
echo
grep 'x_pos' program.f90 | grep -v 'y_pos'
grep 'x_pos' program.f90 | grep -v 'y_pos' | wc -l
```

**Expected Output**
```bash
      REAL :: x_pos, y_pos, z_pos
      x_pos = 0.0
        x_pos = x_pos + velocity_x * 0.01
        PRINT *, 'x_pos =', x_pos
        IF (x_pos > 10.0) THEN
          x_pos = 10.0
        IF (x_pos < -10.0) THEN
          x_pos = -10.0
        PRINT *, 'Updated x_pos:', x_pos
      PRINT *, 'Final x_pos =', x_pos
10

      x_pos = 0.0
        x_pos = x_pos + velocity_x * 0.01
        PRINT *, 'x_pos =', x_pos
        IF (x_pos > 10.0) THEN
          x_pos = 10.0
        IF (x_pos < -10.0) THEN
          x_pos = -10.0
        PRINT *, 'Updated x_pos:', x_pos
      PRINT *, 'Final x_pos =', x_pos
9
```
- **NOTE** that the first line from the original command is no longer present in the second command:
```bash
      REAL :: x_pos, y_pos, z_pos
```


**Explanation:**
- `grep 'x_pos' program.f90`: Searches for lines containing the literal string 'x_pos'
- `|` (pipe): Passes the output from the first command to the next command as input
- `grep -v 'y_pos'`: Filters with the `-v` (invert match) flag to exclude lines containing 'y_pos'
- **Result**: Only lines with x_pos but NOT y_pos are displayed

**Why this solution?**
- Highly portable across different Unix/Linux systems
- Easy to understand and remember
- Efficient for most file sizes
- Works in any POSIX shell

---

### Solution 2: awk (ALTERNATIVE)

```bash
awk '/x_pos/ && !/y_pos/' program.f90
```

**Explanation:**
- `awk`: AWK programming language for text processing
- `/x_pos/`: Regular expression pattern match - selects lines containing x_pos
- `&&`: Logical AND operator - both conditions must be true
- `!/y_pos/`: Negated pattern match - selects lines NOT containing y_pos
- Default action: Print the line (implicit `{ print }`)

**Advantages of awk:**
- Can handle more complex pattern combinations
- Better for fields and structured data
- Single pass through the file (more efficient for large files)
- Allows for calculations and formatting

---

### Solution 3: sed (MOST EFFICIENT)

```bash
sed -n '/x_pos/{ /y_pos/!p }' program.f90
```

**Explanation:**
- `sed`: Stream editor for filtering and transforming text
- `-n`: Suppress automatic printing (only print explicitly)
- `/x_pos/`: Address range - select lines matching x_pos
- `{ /y_pos/!p }`: Command group
  - `/y_pos/`: Second address - lines matching y_pos
  - `!`: Negation operator - REVERSE the condition (lines NOT matching)
  - `p`: Print command
- **Flow**: For lines with x_pos, check if they DON'T have y_pos, then print

**Advantages of sed:**
- Operates in a single pass (most memory efficient)
- Designed for stream processing
- Excellent performance on very large files
- Powerful for complex text transformations

---

## Exercise 2: File Size Comparison

### Problem Statement
Write a script that:
1. Asks for the name of two files
2. Displays the name of the file that has a larger size
3. Assumes files exist and have different sizes

### Solution 1: Interactive with wc (RECOMMENDED)

```bash
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
```

**Key Components Explained:**

#### read command
```bash
read -p "Enter first filename: " file1
```
- `read`: Built-in bash command to read user input
- `-p "prompt"`: Display prompt text (without newline)
- `file1`: Variable name to store the input

#### Command Substitution
```bash
size1=$(wc -c < "$file1")
```
- `$(...)`: Command substitution - executes command and captures output
- `wc -c`: Word count, count bytes
- `< "$file1"`: Redirect file as input to wc
- Result: Stores byte count in variable `size1`

#### Test Operators
```bash
if [ "$size1" -gt "$size2" ]; then
```
- `[ ... ]`: Test command (POSIX compatible)
- `-gt`: Numeric comparison "greater than"
- Other operators: `-lt` (less than), `-eq` (equal), `-ne` (not equal)
- Always quote variables: `"$size1"` prevents issues with spaces

---

### Solution 2: Using ls with sort

```bash
#!/bin/bash

read -p "Enter first filename: " file1
read -p "Enter second filename: " file2

# Display files sorted by size
echo "Files sorted by size:"
ls -lhS "$file1" "$file2"

# Extract larger file
largest=$(ls -lS "$file1" "$file2" | head -1 | awk '{print $NF}')
echo ""
echo "Larger file: $largest"
```

**Explanation:**
- `ls -l`: Long format listing (shows size)
- `ls -h`: Human-readable sizes (KB, MB, etc.)
- `ls -S`: Sort by file size (largest first)
- `head -1`: Take first line (largest file)
- `awk '{print $NF}'`: Extract last field (filename)

---

### Solution 3: Using du (Disk Usage)

```bash
#!/bin/bash

read -p "Enter first filename: " file1
read -p "Enter second filename: " file2

# Show disk usage
du -h "$file1" "$file2"

# Get sizes in bytes for comparison
size1=$(du -b "$file1" | awk '{print $1}')
size2=$(du -b "$file2" | awk '{print $1}')

if [ "$size1" -gt "$size2" ]; then
    echo "Larger file: $file1"
else
    echo "Larger file: $file2"
fi
```
---
## Saving and Running Bash Scripts

To save a bash script and run it, follow these steps:

1. **Create and Save the Script:**
    - Open a text editor (like `nano`, `vim`, or any graphical text editor you prefer).
    - Paste your bash script code into the editor.
    - Save the file with a `.sh` extension, for example: `my_bash_script.sh`.

Example using `nano` editor from terminal:

```bash
nano my_bash_script.sh
```

Paste the code, then press Ctrl+O to save, Enter to confirm filename, and Ctrl+X to exit.

2. **Make the Script Executable:**
    - Before running a script, you need to grant it execute permissions:

```bash
chmod +x my_bash_script.sh
```

3. **Run the Script:**
    - To execute the script, run:

```bash
./my_bash_script.sh
```

---

## Sample Files Reference

### Generated Sample Files

#### 1. program.f90

**Purpose**: Fortran source file for testing pattern matching (Exercise 1)

**Key Characteristics**:
- Contains lines with only `x_pos`
- Contains lines with only `y_pos`
- Contains lines with both `x_pos` AND `y_pos`
- Typical Fortran syntax with comments and declarations
- 53 lines total

**Sample Lines from program.f90**:
```fortran
REAL :: x_pos, y_pos, z_pos          ! Line with both variables
x_pos = 0.0                           ! Line with x_pos only
y_pos = 0.0                           ! Line with y_pos only
PRINT *, 'x_pos =', x_pos             ! Line with x_pos in string
PRINT *, 'Position y_pos =', y_pos    ! Line with y_pos in string
PRINT *, 'Updated x_pos:', x_pos      ! Line with x_pos only
PRINT *, 'Final y_pos:', y_pos        ! Line with y_pos only
```

---

#### 2. small.txt

**Purpose**: Small test file for Exercise 3.2

**Size**: ~300 bytes

**Contents**: Simple repeated text

**Use Case**: Quick testing of file comparison script

---

#### 3. medium.txt

**Purpose**: Medium-sized test file for Exercise 3.2

**Size**: ~7 KB

**Contents**: Mix of two different text patterns repeated

**Use Case**: Compare with small.txt to practice file size operations

---

#### 4. large.txt

**Purpose**: Large test file for Exercise 3.2

**Size**: ~50 KB

**Contents**: Lorem ipsum text repeated 100 times

**Use Case**: Compare with medium.txt or small.txt

---

#### 5. xlarge.txt

**Purpose**: Extra-large test file for Exercise 3.2

**Size**: ~500 KB

**Contents**: Numbered data entries repeated 200 times

**Use Case**: Test script performance with larger files

---

### Generating Sample Files

Run the Python generator script:

```bash
python3 file_generator.py
```

---

## Bash Scripting Tips and Tricks

### Tip 1: Always Quote Variables

```bash
# WRONG - can break if variable contains spaces
if [ $size1 -gt $size2 ]; then

# CORRECT - safe with any content
if [ "$size1" -gt "$size2" ]; then
```

---

### Tip 2: Command Substitution Methods

**Old style (deprecated but works):**
```bash
size=`wc -c < file.txt`
```

**Modern style (recommended):**
```bash
size=$(wc -c < file.txt)
```

---

### Tip 3: Input/Output Redirection

**Redirect file as stdin:**
```bash
wc -c < file.txt        # Better - direct input
wc -c file.txt          # Includes filename in output
```

---

### Tip 4: String Comparison vs Numeric Comparison

```bash
# STRING comparison (alphabetic)
if [ "$a" = "$b" ]; then      # Equal
if [ "$a" != "$b" ]; then     # Not equal

# NUMERIC comparison
if [ "$a" -eq "$b" ]; then    # Equal
if [ "$a" -ne "$b" ]; then    # Not equal
if [ "$a" -lt "$b" ]; then    # Less than
if [ "$a" -gt "$b" ]; then    # Greater than
```

---

### Tip 5: Error Handling

**Check file existence:**
```bash
if [ ! -f "$filename" ]; then
    echo "Error: File not found: $filename"
    exit 1
fi
```

**Check command success:**
```bash
if grep -q 'pattern' file.txt; then
    echo "Pattern found"
else
    echo "Pattern not found"
fi
```

---

### Tip 6: Using Functions in Bash Scripts

```bash
#!/bin/bash

# Function definition
compare_files() {
    local file1="$1"
    local file2="$2"
    
    size1=$(wc -c < "$file1")
    size2=$(wc -c < "$file2")
    
    if [ "$size1" -gt "$size2" ]; then
        echo "$file1"
    else
        echo "$file2"
    fi
}

# Function call
larger=$(compare_files "file1.txt" "file2.txt")
echo "Larger file: $larger"
```

---

### Tip 7: Debugging Bash Scripts

```bash
# Enable debug output
bash -x script.sh

# Or inside script
set -x          # Enable debug
your_command
set +x          # Disable debug
```

---

## Quick Reference Guide

### File Size Commands

| Command | Output |
|---------|--------|
| wc -c file | bytes + filename |
| wc -c < file | bytes only |
| ls -l file | size + metadata |
| stat -c%s file | bytes (Linux) |
| du -b file | blocks |

### Grep Flags

| Flag | Purpose |
|------|---------|
| -v | Invert match (NOT) |
| -i | Case insensitive |
| -n | Show line numbers |
| -c | Count matching lines |
| -E | Extended regex |

### Test Operators for Files

| Operator | Meaning |
|----------|---------|
| -e | File exists |
| -f | Regular file |
| -d | Directory |
| -s | File exists and size > 0 |
| -r | Readable |
| -w | Writable |

### Numeric Comparisons

| Operator | Meaning |
|----------|---------|
| -eq | Equal |
| -ne | Not equal |
| -lt | Less than |
| -le | Less than or equal |
| -gt | Greater than |
| -ge | Greater than or equal |

---

## Complete Working Examples

### Full Solution Script for Exercise 1

```bash
#!/bin/bash
# Exercise 1: Find lines with x_pos but not y_pos

# Method 1: grep pipe (recommended)
echo "=== Method 1: grep pipe ==="
grep 'x_pos' program.f90 | grep -v 'y_pos'

# Method 2: awk
echo ""
echo "=== Method 2: awk ==="
awk '/x_pos/ && !/y_pos/' program.f90

# Method 3: sed
echo ""
echo "=== Method 3: sed ==="
sed -n '/x_pos/{ /y_pos/!p }' program.f90
```

### Full Solution Script for Exercise 2

```bash
#!/bin/bash
# Exercise 2: Compare file sizes

read -p "Enter first filename: " file1
read -p "Enter second filename: " file2

# Validate files
if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
    echo "Error: One or both files not found"
    exit 1
fi

# Get sizes
size1=$(wc -c < "$file1")
size2=$(wc -c < "$file2")

# Display
echo ""
echo "File sizes:"
echo "  $file1: $size1 bytes"
echo "  $file2: $size2 bytes"
echo ""

# Compare and show result
if [ "$size1" -gt "$size2" ]; then
    echo "Larger file: $file1"
else
    echo "Larger file: $file2"
fi
```

---

## Summary

**Exercise 1 - Best Practices:**
- Use `grep 'x_pos' | grep -v 'y_pos'` for simplicity and portability
- Use `awk '/x_pos/ && !/y_pos/'` for more complex conditions
- Use `sed -n '/x_pos/{ /y_pos/!p }'` for best performance on large files

**Exercise 3.2 - Best Practices:**
- Always use variables with quotes: `"$file"`
- Use `wc -c < file` for byte-accurate comparison
- Always validate files exist before processing
- Use numeric comparison operators: `-gt`, `-lt`, `-eq`

**Key Bash Skills Demonstrated:**
- Pattern matching and text filtering
- File operations and metadata retrieval
- Variable assignment and command substitution
- Conditional logic with test operators
- User input handling
- Script organization with functions
