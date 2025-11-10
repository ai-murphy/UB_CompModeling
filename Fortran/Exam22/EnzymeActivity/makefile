# Compiler and flags
FC = gfortran
FFLAGS = -std=f2008 -Wall -O2

# Object files
OBJ = function_expr1.o function_expr2.o main.o

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

# Compile main.f90 (depends on both module object files)
main.o: main.f90 function_expr1.o function_expr2.o
	$(FC) $(FFLAGS) -c main.f90
	@echo "Compiled: main.f90"

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