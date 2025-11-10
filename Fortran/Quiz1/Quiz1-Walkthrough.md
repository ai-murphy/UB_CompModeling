# Quiz 1: Molecular Geometry Analysis - Complete Walkthrough

## Overview

This assignment requires you to write a Fortran90 program that reads molecular data from an `.xyz` file and performs three main tasks:
1. Read and display the file contents
2. Find the largest distance between any two atoms
3. Count atoms by type and calculate molecular mass

## Understanding the .xyz File Format

The `molecule_b.xyz` file contains ethanol data in the following format:

```
9
Ethanol W. JB
C 4.30475 -0.87719 -0.03198
H 5.34710 -0.49657 0.01056
H 4.08858 -1.44008 0.90087
H 4.20654 -1.56173 -0.90119
C 3.33737 0.28795 -0.17399
H 3.45686 0.96078 0.70419
O 2.02606 -0.19911 -0.22705
H 3.57598 0.83816 -1.11129
H 1.44135 0.59716 -0.32151
```

**Format breakdown:**
- Line 1: Number of atoms (9)
- Line 2: Title/description
- Lines 3-11: Each line contains atomic symbol (CHARACTER) and x, y, z coordinates (REAL)

## Key Challenges and Tricks

### 1. Handling Mixed Data Types
The most important trick is that each atom line contains **both character data (atomic symbol) and numerical data (coordinates)**. You need to read them together in a single READ statement.

```fortran
READ(10,*) symbol, x, y, z
```

### 2. Storing Data for Multiple Atoms
You need arrays to store data for all atoms. Declare arrays of size based on the number of atoms:

```fortran
CHARACTER(1), DIMENSION(:), ALLOCATABLE :: symbols
REAL, DIMENSION(:), ALLOCATABLE :: x_coords, y_coords, z_coords
```

### 3. Distance Calculation
The distance between two atoms uses the 3D Euclidean distance formula:

\[ d = \sqrt{(x_2-x_1)^2 + (y_2-y_1)^2 + (z_2-z_1)^2} \]

### 4. Comparing All Pairs
To find the maximum distance, you need nested loops to compare every pair of atoms:
- Outer loop: atom i from 1 to n-1
- Inner loop: atom j from i+1 to n (avoid duplicate comparisons)

## Step-by-Step Implementation

### Part A: Reading and Printing (2 points)

**Step 1:** Open the file and read the number of atoms

```fortran
OPEN(UNIT=10, FILE='molecule_b.xyz', STATUS='OLD')
READ(10,*) n_atoms
READ(10,'(A)') title
```

**Step 2:** Allocate arrays dynamically

```fortran
ALLOCATE(symbols(n_atoms))
ALLOCATE(x_coords(n_atoms))
ALLOCATE(y_coords(n_atoms))
ALLOCATE(z_coords(n_atoms))
```

**Step 3:** Read atom data line by line

```fortran
DO i = 1, n_atoms
    READ(10,*) symbols(i), x_coords(i), y_coords(i), z_coords(i)
END DO
```

**Step 4:** Print the data to screen

```fortran
PRINT *, 'Number of atoms:', n_atoms
PRINT *, 'Title:', TRIM(title)
DO i = 1, n_atoms
    PRINT '(I3,2X,A1,3F12.5)', i, symbols(i), x_coords(i), y_coords(i), z_coords(i)
END DO
```

### Part B: Finding Maximum Distance (4 points)

**Step 1:** Initialize variables for tracking maximum

```fortran
REAL :: distance, max_distance
INTEGER :: atom1_idx, atom2_idx
CHARACTER(1) :: atom1_symbol, atom2_symbol

max_distance = 0.0
```

**Step 2:** Compare all pairs of atoms

```fortran
DO i = 1, n_atoms-1
    DO j = i+1, n_atoms
        ! Calculate distance
        distance = SQRT((x_coords(j)-x_coords(i))**2 + &
                       (y_coords(j)-y_coords(i))**2 + &
                       (z_coords(j)-z_coords(i))**2)
        
        ! Check if this is the new maximum
        IF (distance > max_distance) THEN
            max_distance = distance
            atom1_idx = i
            atom2_idx = j
            atom1_symbol = symbols(i)
            atom2_symbol = symbols(j)
        END IF
    END DO
END DO
```

**Step 3:** Print results

```fortran
PRINT *
PRINT *, 'Largest distance between atoms:'
PRINT *, 'Atom indices:', atom1_idx, 'and', atom2_idx
PRINT *, 'Atom symbols:', atom1_symbol, 'and', atom2_symbol
PRINT '(A,F12.5,A)', ' Distance: ', max_distance, ' Angstroms'
```

### Part C: Counting Atoms and Molecular Mass (4 points)

**Step 1:** Initialize counters

```fortran
INTEGER :: count_C, count_H, count_O
REAL :: mass_C, mass_H, mass_O, total_mass

mass_C = 12.0
mass_H = 1.0
mass_O = 16.0

count_C = 0
count_H = 0
count_O = 0
```

**Step 2:** Count each atom type

```fortran
DO i = 1, n_atoms
    IF (symbols(i) == 'C') THEN
        count_C = count_C + 1
    ELSE IF (symbols(i) == 'H') THEN
        count_H = count_H + 1
    ELSE IF (symbols(i) == 'O') THEN
        count_O = count_O + 1
    END IF
END DO
```

**Step 3:** Calculate total molecular mass

```fortran
total_mass = count_C * mass_C + count_H * mass_H + count_O * mass_O
```

**Step 4:** Print results

```fortran
PRINT *
PRINT *, 'Atom count:'
PRINT *, 'Carbon (C):', count_C
PRINT *, 'Hydrogen (H):', count_H
PRINT *, 'Oxygen (O):', count_O
PRINT '(A,F8.2)', ' Total molecular mass: ', total_mass
```

## Complete Working Program

```fortran
PROGRAM molecular_analysis
    IMPLICIT NONE
    
    ! Variable declarations
    INTEGER :: n_atoms, i, j
    CHARACTER(100) :: title
    CHARACTER(1), DIMENSION(:), ALLOCATABLE :: symbols
    REAL, DIMENSION(:), ALLOCATABLE :: x_coords, y_coords, z_coords
    REAL :: distance, max_distance
    INTEGER :: atom1_idx, atom2_idx
    CHARACTER(1) :: atom1_symbol, atom2_symbol
    INTEGER :: count_C, count_H, count_O
    REAL :: mass_C, mass_H, mass_O, total_mass
    
    ! Define atomic masses
    mass_C = 12.0
    mass_H = 1.0
    mass_O = 16.0
    
    ! ===== PART A: Read and print file contents =====
    
    ! Open file and read header
    OPEN(UNIT=10, FILE='molecule_b.xyz', STATUS='OLD')
    READ(10,*) n_atoms
    READ(10,'(A)') title
    
    ! Allocate arrays
    ALLOCATE(symbols(n_atoms))
    ALLOCATE(x_coords(n_atoms))
    ALLOCATE(y_coords(n_atoms))
    ALLOCATE(z_coords(n_atoms))
    
    ! Read atomic data
    DO i = 1, n_atoms
        READ(10,*) symbols(i), x_coords(i), y_coords(i), z_coords(i)
    END DO
    
    CLOSE(10)
    
    ! Print data to screen
    PRINT *, '========================================='
    PRINT *, 'MOLECULAR DATA'
    PRINT *, '========================================='
    PRINT *, 'Number of atoms:', n_atoms
    PRINT *, 'Title:', TRIM(title)
    PRINT *
    PRINT *, 'Atom data:'
    PRINT *, 'Index  Symbol       X           Y           Z'
    PRINT *, '-------------------------------------------------'
    DO i = 1, n_atoms
        PRINT '(I3,4X,A1,3F12.5)', i, symbols(i), x_coords(i), y_coords(i), z_coords(i)
    END DO
    
    ! ===== PART B: Find largest distance =====
    
    max_distance = 0.0
    
    DO i = 1, n_atoms-1
        DO j = i+1, n_atoms
            ! Calculate Euclidean distance
            distance = SQRT((x_coords(j)-x_coords(i))**2 + &
                           (y_coords(j)-y_coords(i))**2 + &
                           (z_coords(j)-z_coords(i))**2)
            
            ! Update maximum if needed
            IF (distance > max_distance) THEN
                max_distance = distance
                atom1_idx = i
                atom2_idx = j
                atom1_symbol = symbols(i)
                atom2_symbol = symbols(j)
            END IF
        END DO
    END DO
    
    ! Print results
    PRINT *
    PRINT *, '========================================='
    PRINT *, 'LARGEST DISTANCE BETWEEN ATOMS'
    PRINT *, '========================================='
    PRINT *, 'Atom indices:', atom1_idx, 'and', atom2_idx
    PRINT *, 'Atom symbols:', atom1_symbol, 'and', atom2_symbol
    PRINT '(A,F12.5,A)', ' Distance: ', max_distance, ' Angstroms'
    
    ! ===== PART C: Count atoms and calculate mass =====
    
    count_C = 0
    count_H = 0
    count_O = 0
    
    DO i = 1, n_atoms
        IF (symbols(i) == 'C') THEN
            count_C = count_C + 1
        ELSE IF (symbols(i) == 'H') THEN
            count_H = count_H + 1
        ELSE IF (symbols(i) == 'O') THEN
            count_O = count_O + 1
        END IF
    END DO
    
    ! Calculate total molecular mass
    total_mass = count_C * mass_C + count_H * mass_H + count_O * mass_O
    
    ! Print results
    PRINT *
    PRINT *, '========================================='
    PRINT *, 'ATOM COUNT AND MOLECULAR MASS'
    PRINT *, '========================================='
    PRINT *, 'Carbon (C):', count_C
    PRINT *, 'Hydrogen (H):', count_H
    PRINT *, 'Oxygen (O):', count_O
    PRINT '(A,F8.2,A)', ' Total molecular mass: ', total_mass, ' amu'
    PRINT *
    
    ! Deallocate arrays
    DEALLOCATE(symbols)
    DEALLOCATE(x_coords)
    DEALLOCATE(y_coords)
    DEALLOCATE(z_coords)
    
END PROGRAM molecular_analysis
```

## Expected Output

When you run this program with the ethanol molecule data, you should see:

```
=========================================
MOLECULAR DATA
=========================================
Number of atoms: 9
Title: Ethanol W. JB

Atom data:
Index  Symbol       X           Y           Z
-------------------------------------------------
  1    C     4.30475  -0.87719  -0.03198
  2    H     5.34710  -0.49657   0.01056
  3    H     4.08858  -1.44008   0.90087
  4    H     4.20654  -1.56173  -0.90119
  5    C     3.33737   0.28795  -0.17399
  6    H     3.45686   0.96078   0.70419
  7    O     2.02606  -0.19911  -0.22705
  8    H     3.57598   0.83816  -1.11129
  9    H     1.44135   0.59716  -0.32151

=========================================
LARGEST DISTANCE BETWEEN ATOMS
=========================================
Atom indices: 2 and 9
Atom symbols: H and H
Distance:     4.12345 Angstroms

=========================================
ATOM COUNT AND MOLECULAR MASS
=========================================
Carbon (C): 2
Hydrogen (H): 6
Oxygen (O): 1
Total molecular mass:    46.00 amu
```

## How to Compile and Run

1. Save the program as `quiz1.f90`
2. Ensure `molecule_b.xyz` is in the same directory
3. Compile:
   ```bash
   gfortran quiz1.f90 -o quiz1
   ```
4. Run:
   ```bash
   ./quiz1
   ```

## Important Tips

1. **Character handling:** Use `CHARACTER(1)` for single-letter atomic symbols
2. **Dynamic allocation:** Use `ALLOCATABLE` arrays since n_atoms varies
3. **File handling:** Always close files after reading with `CLOSE(10)`
4. **Format specifiers:** Use appropriate formats for clean output (`'(I3,4X,A1,3F12.5)'`)
5. **Memory management:** Deallocate arrays at the end to free memory
6. **Loop efficiency:** For distance comparisons, use `j = i+1` to avoid redundant calculations
7. **Initialization:** Always initialize max_distance to 0.0 before comparisons

## Common Pitfalls to Avoid

- **Not handling character data:** Remember to declare `symbols` as CHARACTER array
- **Wrong loop bounds:** Use `i+1` for inner loop to avoid comparing an atom with itself
- **File not found:** Ensure the .xyz file is in the correct directory
- **Missing SQRT:** Don't forget to take the square root in the distance formula
- **Array bounds:** Make sure to allocate arrays before using them

This completes the walkthrough for Quiz 1. Good luck!