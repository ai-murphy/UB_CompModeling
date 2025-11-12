FC = gfortran
FFLAGS = -O2 -std=f2003
OBJS = utils_module.o mass_module.o distance_module.o groups_module.o main.o
TARGET = molecule_analyzer

all: $(TARGET)

$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $(TARGET) $(OBJS)

utils_module.o: utils_module.f90
	$(FC) $(FFLAGS) -c utils_module.f90

mass_module.o: mass_module.f90 utils_module.f90
	$(FC) $(FFLAGS) -c mass_module.f90

distance_module.o: distance_module.f90 utils_module.f90
	$(FC) $(FFLAGS) -c distance_module.f90

groups_module.o: groups_module.f90 distance_module.f90 utils_module.f90
	$(FC) $(FFLAGS) -c groups_module.f90

main.o: main.f90 utils_module.f90 mass_module.f90 distance_module.f90 groups_module.f90
	$(FC) $(FFLAGS) -c main.f90

clean:
	rm -f *.o $(TARGET)
.PHONY: all clean
