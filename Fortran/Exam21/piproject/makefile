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