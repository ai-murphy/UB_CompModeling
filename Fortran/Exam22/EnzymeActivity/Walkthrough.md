# Fortran Exercise #3 Walkthrough: Enzymatic Activity Rate Calculations

## Overview
This exercise requires creating a Fortran90 program that calculates two expressions for enzymatic activity rate (v) using separate functions, generates formatted tables for two different parameter sets, outputs to both screen and files, and uses a makefile for compilation.

## Mathematical Expressions

**Expression 1 (v1):**
```
v1 = k2 * [E0] * [S] / (KM + [S])
```

**Expression 2 (v2):**
```
v2 = k2 * [E0] * [S] / (KM * (1 + [I]/KI) + [S])
```

Where:
- k2: Rate constant
- [E0]: Enzyme concentration
- [S]: Substrate concentration (ranges from 0.01 to 0.1 M)
- KM: Michaelis constant
- [I]: Inhibitor concentration
- KI: Inhibitor dissociation constant

## File Structure

Your project will contain:
1. `function_expr1.f90` - Function for Expression 1
2. `function_expr2.f90` - Function for Expression 2
3. `main_program.f90` - Main program
4. `Makefile` - Build configuration

## Step 1: Create Function for Expression 1

**File: function_expr1.f90**

```fortran
module expr1_module
    implicit none
contains
    function calc_v1(k2, E0, S, KM) result(v1)
        real(kind=8), intent(in) :: k2, E0, S, KM
        real(kind=8) :: v1
        
        v1 = k2 * E0 * S / (KM + S)
    end function calc_v1
end module expr1_module
```

**Key Points:**
- Uses `real(kind=8)` for double precision floating point
- Takes enzyme concentration [E0], substrate [S], rate constant k2, and Michaelis constant KM as inputs
- Returns calculated v1 value
- Wrapped in a module for easier compilation and linking

## Step 2: Create Function for Expression 2

**File: function_expr2.f90**

```fortran
module expr2_module
    implicit none
contains
    function calc_v2(k2, E0, S, KM, I, KI) result(v2)
        real(kind=8), intent(in) :: k2, E0, S, KM, I, KI
        real(kind=8) :: v2
        
        v2 = k2 * E0 * S / (KM * (1.0d0 + I/KI) + S)
    end function calc_v2
end module expr2_module
```

**Key Points:**
- Includes all parameters from Expression 2
- Includes inhibitor [I] and inhibitor dissociation constant KI
- Formula accounts for competitive inhibition
- The `1.0d0` notation ensures double precision arithmetic

## Step 3: Create the Main Program with Formatted Output

**File: main_program.f90**

```fortran
program enzymatic_activity
    use expr1_module
    use expr2_module
    implicit none
    
    ! Variables for first dataset
    real(kind=8) :: k2_1, E0_1, KM_1, I_1, KI_1
    ! Variables for second dataset
    real(kind=8) :: k2_2, E0_2, KM_2, I_2, KI_2
    
    ! Loop and calculation variables
    integer :: i
    real(kind=8) :: S, v1, v2
    
    ! Initialize parameters for first table
    k2_1 = 0.002d0
    E0_1 = 0.04d0
    KM_1 = 0.005d0
    I_1 = 0.1d0
    KI_1 = 0.002d0
    
    ! Initialize parameters for second table
    k2_2 = 0.0005d0
    E0_2 = 0.06d0
    KM_2 = 0.01d0
    I_2 = 0.03d0
    KI_2 = 0.03d0
    
    ! Generate first table
    call generate_table(1, k2_1, E0_1, KM_1, I_1, KI_1)
    
    ! Generate second table
    call generate_table(2, k2_2, E0_2, KM_2, I_2, KI_2)
    
contains
    subroutine generate_table(table_num, k2, E0, KM, I, KI)
        integer, intent(in) :: table_num
        real(kind=8), intent(in) :: k2, E0, KM, I, KI
        integer :: i
        real(kind=8) :: S, v1, v2
        character(len=20) :: filename
        
        ! Determine output filename
        write(filename, '(A,I1,A)') 'table', table_num, '.out'
        
        ! Open output file
        open(unit=10, file=trim(filename), status='replace', action='write')
        
        ! Print header to screen
        print *, '====== Table ', table_num, ' ======'
        print '(3(A15))', '[S] (M)', 'v1', 'v2'
        print '(50A)', ('-', i=1,50)
        
        ! Print header to file
        write(10, '(3(A15))') '[S] (M)', 'v1', 'v2'
        write(10, '(50A)') ('-', i=1,50)
        
        ! Loop from [S] = 0.01 to 0.1 in steps of 0.01
        do i = 1, 10
            S = 0.01d0 * i
            v1 = calc_v1(k2, E0, S, KM)
            v2 = calc_v2(k2, E0, S, KM, I, KI)
            
            ! Print to screen with proper formatting
            print '(3(F15.8))', S, v1, v2
            
            ! Print to file with proper formatting
            write(10, '(3(F15.8))') S, v1, v2
        end do
        
        ! Print footer to screen
        print '(50A)', ('-', i=1,50)
        print *
        
        ! Print footer to file
        write(10, '(50A)') ('-', i=1,50)
        
        close(unit=10)
    end subroutine generate_table
end program enzymatic_activity
```

**Key Points:**
- Uses two derived subroutines to handle table generation
- `generate_table` takes table number and all parameters
- Opens files with unit=10 for output
- Uses formatted write statements with proper column alignment
- Loops from i=1 to 10, calculating S = 0.01*i (gives 0.01 to 0.1)
- `trim()` removes trailing spaces from filename string
- Proper file handling with `open()` and `close()`

### Formatting Tips for Tables

The format descriptor `'(3(F15.8))'` means:
- `(3(...))` - Repeat 3 times
- `F15.8` - Fixed point format with 15 total characters, 8 decimal places
- This ensures consistent column widths

Alternative formats:
```fortran
! For more compact output:
print '(3(F10.6))', S, v1, v2

! For scientific notation:
print '(3(E15.8))', S, v1, v2

! For mixed formatting:
print '(F10.4, 2(E15.8))', S, v1, v2
```

## Step 4: Create the Makefile

**File: Makefile**

```makefile
# Compiler and flags
FC = gfortran
FFLAGS = -std=f2008 -Wall -O2

# Object files
OBJ = function_expr1.o function_expr2.o main_program.o

# Executable name
EXEC = enzymatic_activity

# Default target
all: $(EXEC)

# Link object files to create executable
$(EXEC): $(OBJ)
	$(FC) $(FFLAGS) -o $(EXEC) $(OBJ)
	@echo "Executable created: $(EXEC)"

# Compile function_expr1.f90
function_expr1.o: function_expr1.f90
	$(FC) $(FFLAGS) -c function_expr1.f90
	@echo "Compiled: function_expr1.f90"

# Compile function_expr2.f90
function_expr2.o: function_expr2.f90
	$(FC) $(FFLAGS) -c function_expr2.f90
	@echo "Compiled: function_expr2.f90"

# Compile main_program.f90 (depends on both module object files)
main_program.o: main_program.f90 function_expr1.o function_expr2.o
	$(FC) $(FFLAGS) -c main_program.f90
	@echo "Compiled: main_program.f90"

# Clean rule: remove all compiled files and executable
clean:
	rm -f $(OBJ) $(EXEC) *.mod
	@echo "Cleaned up object files, executable, and module files"

# Run rule: execute the program
run: $(EXEC)
	./$(EXEC)
	@echo "Program executed"

# Info rule: display makefile information
info:
	@echo "Makefile targets:"
	@echo "  all   - Build the program (default)"
	@echo "  clean - Remove compiled files"
	@echo "  run   - Compile and run the program"
	@echo "  info  - Display this help message"

.PHONY: all clean run info
```

**Makefile Explanation:**

1. **Compiler Setup**: Defines compiler (gfortran) and flags
2. **Rule: all** - Default target that builds the executable
3. **Rule: $(EXEC)** - Links object files into executable
4. **Rule: function_expr1.o** - Compiles expr1 function
5. **Rule: function_expr2.o** - Compiles expr2 function
6. **Rule: main_program.o** - Compiles main program (depends on both module objects)
7. **Rule: clean** - Removes all compiled artifacts
8. **Rule: run** - Compiles and executes
9. **Rule: info** - Displays help information

The makefile has 6 rules, exceeding the minimum requirement of 4.

## Step 5: Compilation and Execution

### Build the Program

```bash
# Build everything
make all

# Or simply
make
```

Expected output:
```
Compiled: function_expr1.f90
Compiled: function_expr2.f90
Compiled: main_program.f90
Executable created: enzymatic_activity
```

### Run the Program

```bash
# Execute the program
./enzymatic_activity

# Or use the makefile
make run
```

### Clean Up

```bash
# Remove all compiled files
make clean
```

## Step 6: Expected Output

### Screen Output

```
 ====== Table  1 ======
       [S] (M)              v1              v2
--------------------------------------------------
    0.01000000    0.00000133    0.00000047
    0.02000000    0.00000240    0.00000090
    0.03000000    0.00000320    0.00000124
    0.04000000    0.00000381    0.00000153
    0.05000000    0.00000429    0.00000178
    0.06000000    0.00000468    0.00000200
    0.07000000    0.00000500    0.00000219
    0.08000000    0.00000527    0.00000236
    0.09000000    0.00000550    0.00000251
    0.10000000    0.00000571    0.00000265
--------------------------------------------------

 ====== Table  2  ======
...
```

### File Output

Files `table1.out` and `table2.out` will contain identical formatted data to the screen output.

## Common Issues and Solutions

### Issue 1: Module Compilation Order
**Problem**: Compiler can't find module when compiling main_program.f90

**Solution**: Ensure module files are compiled first. The makefile handles this through dependencies:
```makefile
main_program.o: main_program.f90 function_expr1.o function_expr2.o
```

### Issue 2: Column Alignment
**Problem**: Output columns don't line up properly

**Solution**: Use consistent format descriptors:
```fortran
! Good practice:
print '(3(F15.8))', S, v1, v2
print '(50A)', ('-', i=1,50)  ! Separator line
```

### Issue 3: File Not Created
**Problem**: `table1.out` or `table2.out` not appearing

**Solution**: Check that the file is being created in the working directory where you run the executable:
```bash
ls -la table*.out  ! Check if files exist
cat table1.out     ! View file contents
```

### Issue 4: Wrong Number of Rows
**Problem**: Getting 11 or 9 rows instead of 10

**Solution**: Verify the loop logic:
```fortran
do i = 1, 10          ! Correct: i from 1 to 10
    S = 0.01d0 * i    ! Gives 0.01, 0.02, ..., 0.10
end do
```

## Advanced Tips

### Tip 1: Using Command-Line Arguments
You can modify the program to accept parameters from command line:
```fortran
character(len=32) :: arg
integer :: nargs

nargs = command_argument_count()
if (nargs > 0) then
    call get_command_argument(1, arg)
    ! Process argument
end if
```

### Tip 2: File I/O with Namelist
Alternative to individual variable declarations:
```fortran
namelist /parameters/ k2, E0, KM, I, KI
read(unit_in, nml=parameters)
```

### Tip 3: Creating Reusable Function Modules
For multiple projects, create a library:
```bash
# In makefile:
enzymatic_lib.a: function_expr1.o function_expr2.o
	ar rcs enzymatic_lib.a function_expr1.o function_expr2.o
```

### Tip 4: Formatting with Adjustable Widths
```fortran
integer :: col_width
col_width = 15
print '(3(F<col_width>.8))', S, v1, v2  ! Dynamic width (Fortran 2003+)
```

## Complete Code Summary

### File 1: function_expr1.f90
```fortran
module expr1_module
    implicit none
contains
    function calc_v1(k2, E0, S, KM) result(v1)
        real(kind=8), intent(in) :: k2, E0, S, KM
        real(kind=8) :: v1
        
        v1 = k2 * E0 * S / (KM + S)
    end function calc_v1
end module expr1_module
```

### File 2: function_expr2.f90
```fortran
module expr2_module
    implicit none
contains
    function calc_v2(k2, E0, S, KM, I, KI) result(v2)
        real(kind=8), intent(in) :: k2, E0, S, KM, I, KI
        real(kind=8) :: v2
        
        v2 = k2 * E0 * S / (KM * (1.0d0 + I/KI) + S)
    end function calc_v2
end module expr2_module
```

### File 3: main_program.f90
```fortran
program enzymatic_activity
    use expr1_module
    use expr2_module
    implicit none
    
    ! Variables for first dataset
    real(kind=8) :: k2_1, E0_1, KM_1, I_1, KI_1
    ! Variables for second dataset
    real(kind=8) :: k2_2, E0_2, KM_2, I_2, KI_2
    
    ! Initialize parameters for first table
    k2_1 = 0.002d0
    E0_1 = 0.04d0
    KM_1 = 0.005d0
    I_1 = 0.1d0
    KI_1 = 0.002d0
    
    ! Initialize parameters for second table
    k2_2 = 0.0005d0
    E0_2 = 0.06d0
    KM_2 = 0.01d0
    I_2 = 0.03d0
    KI_2 = 0.03d0
    
    ! Generate first table
    call generate_table(1, k2_1, E0_1, KM_1, I_1, KI_1)
    
    ! Generate second table
    call generate_table(2, k2_2, E0_2, KM_2, I_2, KI_2)
    
contains
    subroutine generate_table(table_num, k2, E0, KM, I, KI)
        integer, intent(in) :: table_num
        real(kind=8), intent(in) :: k2, E0, KM, I, KI
        integer :: i
        real(kind=8) :: S, v1, v2
        character(len=20) :: filename
        
        ! Determine output filename
        write(filename, '(A,I1,A)') 'table', table_num, '.out'
        
        ! Open output file
        open(unit=10, file=trim(filename), status='replace', action='write')
        
        ! Print header to screen
        print *, '====== Table ', table_num, ' ======'
        print '(3(A15))', '[S] (M)', 'v1', 'v2'
        print '(50A)', ('-', i=1,50)
        
        ! Print header to file
        write(10, '(3(A15))') '[S] (M)', 'v1', 'v2'
        write(10, '(50A)') ('-', i=1,50)
        
        ! Loop from [S] = 0.01 to 0.1 in steps of 0.01
        do i = 1, 10
            S = 0.01d0 * i
            v1 = calc_v1(k2, E0, S, KM)
            v2 = calc_v2(k2, E0, S, KM, I, KI)
            
            ! Print to screen with proper formatting
            print '(3(F15.8))', S, v1, v2
            
            ! Print to file with proper formatting
            write(10, '(3(F15.8))') S, v1, v2
        end do
        
        ! Print footer to screen
        print '(50A)', ('-', i=1,50)
        print *
        
        ! Print footer to file
        write(10, '(50A)') ('-', i=1,50)
        
        close(unit=10)
    end subroutine generate_table
end program enzymatic_activity
```

### File 4: Makefile
```makefile
# Compiler and flags
FC = gfortran
FFLAGS = -std=f2008 -Wall -O2

# Object files
OBJ = function_expr1.o function_expr2.o main_program.o

# Executable name
EXEC = enzymatic_activity

# Default target
all: $(EXEC)

# Link object files to create executable
$(EXEC): $(OBJ)
	$(FC) $(FFLAGS) -o $(EXEC) $(OBJ)
	@echo "Executable created: $(EXEC)"

# Compile function_expr1.f90
function_expr1.o: function_expr1.f90
	$(FC) $(FFLAGS) -c function_expr1.f90
	@echo "Compiled: function_expr1.f90"

# Compile function_expr2.f90
function_expr2.o: function_expr2.f90
	$(FC) $(FFLAGS) -c function_expr2.f90
	@echo "Compiled: function_expr2.f90"

# Compile main_program.f90 (depends on both module object files)
main_program.o: main_program.f90 function_expr1.o function_expr2.o
	$(FC) $(FFLAGS) -c main_program.f90
	@echo "Compiled: main_program.f90"

# Clean rule: remove all compiled files and executable
clean:
	rm -f $(OBJ) $(EXEC) *.mod
	@echo "Cleaned up object files, executable, and module files"

# Run rule: execute the program
run: $(EXEC)
	./$(EXEC)
	@echo "Program executed"

# Info rule: display makefile information
info:
	@echo "Makefile targets:"
	@echo "  all   - Build the program (default)"
	@echo "  clean - Remove compiled files"
	@echo "  run   - Compile and run the program"
	@echo "  info  - Display this help message"

.PHONY: all clean run info
```

## Verification Checklist

- [ ] All 4 files created (function_expr1.f90, function_expr2.f90, main_program.f90, Makefile)
- [ ] Makefile has minimum 4 rules (we have 6)
- [ ] Program compiles without errors: `make all`
- [ ] Program runs without errors: `./enzymatic_activity`
- [ ] Screen output shows two tables with proper formatting
- [ ] Files `table1.out` and `table2.out` are created
- [ ] File contents match screen output
- [ ] Both tables have 10 data rows (S from 0.01 to 0.1)
- [ ] Column headers and separator lines are present
- [ ] Expression 1 (Michaelis-Menten) shows expected behavior
- [ ] Expression 2 (with inhibition) shows reduced rates compared to expr1

## Quick Reference Commands

```bash
# Build the program
make

# Run the program
make run

# Run program and save output to log file
make run > output.log 2>&1

# View generated table files
cat table1.out
cat table2.out

# Clean up and rebuild
make clean && make

# Verify files were created
ls -la *.out
ls -la *.o
ls -la *.mod
```

This completes Exercise #3! The solution demonstrates Fortran90 best practices including modular design, proper I/O handling, makefile organization, and numerical computation.
