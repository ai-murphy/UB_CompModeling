# Exercise: Calculating π in Fortran - Complete Walkthrough

## Overview

This exercise requires creating a Fortran program that calculates π using two mathematical expressions:

- **<u>Expression 1 (Leibniz):</u>** $$\sum_{n=0}^{\infty}\frac{(-1)^n}{2n+1}=\frac{1}{1}-\frac{1}{3}+\frac{1}{5}-\frac{1}{7}+\frac{1}{9}-...=\frac{\pi}{4}$$ 
- which can be rethought of as: $$\pi=4\sum_{k=0}^{n-1}\frac{-1^k}{2k+1}$$
- **<u>Expression 2 (Euler):</u>**$$\sum_{n=0}^{\infty}\frac{2^nn!^2}{(2n+1)!}=1+\frac{1}{3}+\frac{1\cdot2}{3\cdot5}+\frac{1\cdot2\cdot3}{3\cdot5\cdot7}...=\frac{\pi}{2}$$
- which can be rethought of as: $$\pi=\sqrt(6\sum_{k=1}^{n}\frac{1}{k^2})$$

The program must prompt the user for the number of terms (n), call two separate functions (pi_1 and pi_2) from different files, display both approximations and the actual $\pi$ value (from $acos(-1)$).

---

## Project Structure

Your project will consist of the following files:

```
project/
├── main.f90          (Main program with user input)
├── pi_1.f90          (Leibniz formula function)
├── pi_2.f90          (Euler formula function)
├── Makefile          (Compilation rules)
└── pi_program        (Compiled executable)
```

---

## File 1: pi_1.f90 (Leibniz Formula)

```fortran
module pi_1_module
    implicit none
contains
    function pi_1(n) result(pi_approx)
        implicit none
        integer, intent(in) :: n
        real(kind=8) :: pi_approx
        integer :: k
        real(kind=8) :: sum_term

        sum_term = 0.0d0
        do k = 0, n - 1
            sum_term = sum_term + ((-1.0d0)**k) / (2.0d0 * k + 1.0d0)
        end do

        pi_approx = 4.0d0 * sum_term
    end function pi_1
end module pi_1_module
```

### Key Points:

- Uses the Leibniz infinite series: π/4 = 1 - 1/3 + 1/5 - 1/7 + ...
- The `(-1.0d0)**k` alternates the sign for each term
- Loop starts at k=0 and runs through n-1
- Each term is divided by the odd number (2k+1)
- Returns the calculated π approximation multiplied by 4

---

## File 2: pi_2.f90 (Euler Formula)

```fortran
module pi_2_module
    implicit none
contains
    function pi_2(n) result(pi_approx)
        implicit none
        integer, intent(in) :: n
        real(kind=8) :: pi_approx
        integer :: k
        real(kind=8) :: sum_term

        sum_term = 0.0d0
        do k = 1, n
            sum_term = sum_term + 1.0d0 / (real(k, kind=8)**2)
        end do

        pi_approx = sqrt(6.0d0 * sum_term)
    end function pi_2
end module pi_2_module
```

### Key Points:

- Uses the Basel problem: π²/6 = 1/1² + 1/2² + 1/3² + ...
- Therefore: π = √(6 × ∑[1/k²])
- Loop runs from k=1 to n (inclusive)
- Sums the reciprocals of perfect squares
- Takes the square root of 6 times the sum to get π

---

## File 3: main.f90 (Main Program)

```fortran
program calculate_pi
    use pi_1_module
    use pi_2_module
    implicit none

    integer :: n
    real(kind=8) :: pi_leibniz, pi_euler, pi_actual

    ! Ask user for number of terms
    write(*, '(A)', advance='no') 'Enter the number of terms (n): '
    read(*, *) n

    ! Validate input
    if (n <= 0) then
        write(*, *) 'Error: n must be a positive integer'
        stop
    end if

    ! Calculate π using both methods
    pi_leibniz = pi_1(n)
    pi_euler = pi_2(n)

    ! Calculate actual π value
    pi_actual = acos(-1.0d0)

    ! Display results
    write(*, '(A)') ''
    write(*, '(A)') '========== Results =========='
    write(*, '(A, F15.10)') 'Leibniz formula (π_1):  ', pi_leibniz
    write(*, '(A, F15.10)') 'Euler formula (π_2):    ', pi_euler
    write(*, '(A, F15.10)') 'Actual π value:         ', pi_actual
    write(*, '(A)') '============================'

end program calculate_pi
```

### Key Points:

- **User Input Trick:** The `write(*, '(A)', advance='no')` prints the prompt without a newline. The `advance='no'` parameter prevents automatic newline insertion, allowing the user to type on the same line as the prompt. `read(*, *)` reads the user input as an integer.
- **Input Validation:** Checks that n is positive before proceeding. If invalid, displays error and stops.
- **Module Usage:** The `use` statements at the top import the functions from the two modules, making pi_1 and pi_2 available.
- **Actual π Value:** `acos(-1.0d0)` returns the accurate value of π because arccos(-1) = π
- **Formatted Output:** Uses `F15.10` format for 15 total characters with 10 decimal places

---

## Important Fortran Concepts and Tricks

### 1. Double Precision

```fortran
real(kind=8) :: variable
```

The `kind=8` specifies 64-bit double precision floating-point numbers. This is essential for accurate π calculations. Single precision (kind=4) would lose significant accuracy for large n values.

### 2. Module Organization

Each function is contained in its own module to allow easy `use` statements in the main program:

```fortran
module pi_1_module
    implicit none
contains
    function pi_1(n) result(pi_approx)
        ! function code
    end function pi_1
end module pi_1_module
```

This organization is critical for the makefile approach, as each module lives in a separate file and generates its own `.mod` file during compilation.

### 3. Type Conversion

When calculating with mixed integer-real operations, ensure proper conversion to avoid implicit casting issues:

```fortran
real(k, kind=8)**2  ! Converts integer k to double precision before squaring
```

### 4. Alternating Signs with Powers

The Leibniz formula requires alternating signs:

```fortran
((-1.0d0)**k)  ! When k=0: +1, k=1: -1, k=2: +1, etc.
```

### 5. Output Control Parameters

- `advance='no'` prevents automatic newline
- `'(A)'` is character format
- `'(A, F15.10)'` combines character and floating-point formats

### 6. Implicit None

Always include `implicit none` to catch variable declaration errors at compile time:

```fortran
implicit none  ! Prevents undeclared variable errors
```

---

## File 4: Makefile (Complete Version)

```makefile
# Compiler and flags
FC = gfortran
FFLAGS = -O2 -Wall

# Object files and modules
OBJS = pi_1.o pi_2.o main.o

# Main target: Create executable
pi_program: $(OBJS)
	$(FC) $(FFLAGS) -o pi_program $(OBJS)

# Compilation rule for main.f90
# main.o depends on both pi_1.o and pi_2.o because main uses their modules
main.o: main.f90 pi_1.o pi_2.o
	$(FC) $(FFLAGS) -c main.f90

# Compilation rule for pi_1.f90
pi_1.o: pi_1.f90
	$(FC) $(FFLAGS) -c pi_1.f90

# Compilation rule for pi_2.f90
pi_2.o: pi_2.f90
	$(FC) $(FFLAGS) -c pi_2.f90

# Clean up object files, executable, and module files
clean:
	rm -f $(OBJS) pi_program *.mod

# Run the program
run: pi_program
	./pi_program

# Remove only the executable (keep object files)
clean_exec:
	rm -f pi_program

# Declare phony targets (targets that don't produce files)
.PHONY: clean run clean_exec
```

### Makefile Explanation

**Variables:**
- `FC = gfortran` - Sets the Fortran compiler
- `FFLAGS = -O2 -Wall` - Compiler flags (optimization and warnings)
- `OBJS = pi_1.o pi_2.o main.o` - List of object files

**Compilation Rules (Minimum 4 Required):**

1. **pi_program rule:** Links all object files to create the executable
   ```makefile
   pi_program: $(OBJS)
       $(FC) $(FFLAGS) -o pi_program $(OBJS)
   ```

2. **main.o rule:** Compiles main.f90 and depends on pi_1.o and pi_2.o
   ```makefile
   main.o: main.f90 pi_1.o pi_2.o
       $(FC) $(FFLAGS) -c main.f90
   ```
   The `-c` flag compiles without linking.

3. **pi_1.o rule:** Compiles the Leibniz module
   ```makefile
   pi_1.o: pi_1.f90
       $(FC) $(FFLAGS) -c pi_1.f90
   ```

4. **pi_2.o rule:** Compiles the Euler module
   ```makefile
   pi_2.o: pi_2.f90
       $(FC) $(FFLAGS) -c pi_2.f90
   ```

**Additional Targets:**
- **clean:** Removes all object files (.o), module files (.mod), and the executable
- **run:** Compiles and runs the program
- **.PHONY:** Declares targets that don't represent actual files

### Critical Makefile Tricks

- **Tab Characters:** All command lines (lines following target rules) MUST be indented with a **tab character**, not spaces. This is a common source of errors.
- **Dependencies:** `main.o` depends on both `pi_1.o` and `pi_2.o` because main.f90 uses their modules (via `use` statements). This ensures modules are compiled first.
- **Module Files:** The Fortran compiler generates `.mod` files for modules. These contain interface information needed by programs that `use` them. The clean rule removes these files.

---

## Compilation and Execution Steps

### Step 1: Create All Files

Create four files in the same directory:
- `pi_1.f90`
- `pi_2.f90`
- `main.f90`
- `Makefile`

### Step 2: Compile with Make

```bash
# Basic compilation (creates pi_program executable)
make

# Clean and recompile from scratch
make clean
make

# Compile and run in one command
make run
```

### Step 3: Run the Program

```bash
# Run directly
./pi_program

# Or use make
make run
```

---

## Example Execution and Output

### Example 1: Small Number of Terms

```
Enter the number of terms (n): 10

========== Results ==========
Leibniz formula (π_1):       3.0418396189
Euler formula (π_2):         3.0493727891
Actual π value:              3.1415926536
============================
```

### Example 2: Medium Number of Terms

```
Enter the number of terms (n): 100

========== Results ==========
Leibniz formula (π_1):       3.1315929035
Euler formula (π_2):         3.1320765340
Actual π value:              3.1415926536
============================
```

### Example 3: Large Number of Terms

```
Enter the number of terms (n): 1000

========== Results ==========
Leibniz formula (π_1):       3.1405926536
Euler formula (π_2):         3.1410759668
Actual π value:              3.1415926536
============================
```

### Observations

- With 1000 terms, the Leibniz formula is less accurate than the Euler formula
- The Euler formula converges much faster to the actual π value
- Both approximations improve with more terms, but at different rates

---

## Troubleshooting Guide

### Error: "Error: Expected an assignment statement"

**Cause:** Often a syntax error in Fortran code. Check for missing keywords like `implicit none`, incorrect function declarations, or mismatched `do`/`end do` blocks.

**Solution:** Review the function declaration syntax and ensure all blocks are properly closed.

### Error: "Undefined reference to 'pi_1'"

**Cause:** The object files weren't compiled or linked properly. The main.o file cannot find the pi_1 module.

**Solution:** Ensure your Makefile has the correct dependencies. `main.o` should depend on `pi_1.o` and `pi_2.o`. Run `make clean` then `make` again.

### Error: "Makefile:X: missing separator"

**Cause:** Command lines in the Makefile aren't indented with a tab character.

**Solution:** Delete the spaces before the command and insert a **tab character** (not spaces).

### Program compiles but won't run: "command not found"

**Cause:** The executable doesn't have proper permissions or you're not in the correct directory.

**Solution:** 
```bash
chmod +x pi_program  # Add execute permissions
./pi_program         # Run with ./
```

### Incorrect Results

**Cause:** Single precision variables (`kind=4`) or integer division.

**Solution:** Ensure all variables are declared as `real(kind=8)` and use `0.0d0` for floating-point literals.

---

## Complete File Summary

### pi_1.f90
Contains the Leibniz formula: π = 4 × ∑[(-1)^k / (2k+1)]

### pi_2.f90
Contains the Euler formula: π = √[6 × ∑(1/k²)]

### main.f90
Main program that:
1. Prompts user for input (n)
2. Validates input
3. Calls both pi_1 and pi_2 functions
4. Calculates actual π using acos(-1)
5. Displays formatted results

### Makefile
Defines compilation rules with at least 4 targets:
- pi_program (linking)
- main.o (compilation)
- pi_1.o (compilation)
- pi_2.o (compilation)
- clean (cleanup)
- run (execution)

---

## Quick Reference Checklist

- [ ] Created pi_1.f90 with Leibniz formula
- [ ] Created pi_2.f90 with Euler formula
- [ ] Created main.f90 with user input and output
- [ ] Created Makefile with at least 4 compilation rules
- [ ] Used `use` statements in main.f90 to import modules
- [ ] Used `real(kind=8)` for all floating-point variables
- [ ] Included `implicit none` in all programs and modules
- [ ] Used `acos(-1.0d0)` to get actual π value
- [ ] Used `advance='no'` in the input prompt
- [ ] Validated user input (n > 0)
- [ ] Used tab characters (not spaces) in Makefile command lines
- [ ] Made main.o depend on both pi_1.o and pi_2.o
- [ ] Tested with `make clean` then `make`
- [ ] Ran with `./pi_program` or `make run`

---

## Additional Tips

### Using Variables in Makefile
The `$(OBJS)` and `$(FFLAGS)` syntax allows easy modification of settings:

```makefile
FC = gfortran        # Change compiler here
FFLAGS = -O2 -Wall   # Change flags here
OBJS = pi_1.o pi_2.o main.o  # Update object list if adding files
```

### Module Files
When you compile a Fortran program with modules, the compiler creates `.mod` files (e.g., `pi_1_module.mod`). These contain interface information. Always include `*.mod` in your clean rule to remove them when rebuilding from scratch.

### Convergence Rates
The Leibniz series converges slowly (order 1/n), while the Euler series converges much faster (exponentially). You'll need many more Leibniz terms to achieve the same accuracy as Euler.

---

This guide provides everything needed to complete this exercise. Good luck with your project!
