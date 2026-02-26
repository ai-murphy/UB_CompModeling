# authored by: Person A
FC = gfortran
FFLAGS = -O3 -Wall
OMPFLAGS = -fopenmp

SRC_DIR = src
OBJ_DIR = obj

SRCS = $(SRC_DIR)/kinds_mod.f90 $(SRC_DIR)/polymer_mod.f90 $(SRC_DIR)/energy_mod.f90 $(SRC_DIR)/mc_mod.f90 $(SRC_DIR)/main.f90
OBJS = $(patsubst $(SRC_DIR)/%.f90,$(OBJ_DIR)/%.o,$(SRCS))
OBJS_OMP = $(patsubst $(SRC_DIR)/%.f90,$(OBJ_DIR)/%_omp.o,$(SRCS))

TARGET_SERIAL = poly_mc_serial
TARGET_OMP = poly_mc_omp

all: $(TARGET_SERIAL) $(TARGET_OMP)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Serial Compilation
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90 | $(OBJ_DIR)
	$(FC) $(FFLAGS) -J$(OBJ_DIR) -c $< -o $@

$(TARGET_SERIAL): $(OBJS)
	$(FC) $(FFLAGS) -J$(OBJ_DIR) $^ -o $@

# Parallel Compilation
$(OBJ_DIR)/%_omp.o: $(SRC_DIR)/%.f90 | $(OBJ_DIR)
	$(FC) $(FFLAGS) $(OMPFLAGS) -J$(OBJ_DIR) -c $< -o $@

$(TARGET_OMP): $(OBJS_OMP)
	$(FC) $(FFLAGS) $(OMPFLAGS) -J$(OBJ_DIR) $^ -o $@

run_serial: $(TARGET_SERIAL)
	./$(TARGET_SERIAL)

run_parallel: $(TARGET_OMP)
	OMP_NUM_THREADS=4 ./$(TARGET_OMP)

plot:
	python3 scripts/analyze_polymer.py

clean:
	rm -rf $(OBJ_DIR) $(TARGET_SERIAL) $(TARGET_OMP) *.dat *.pdb *.png
