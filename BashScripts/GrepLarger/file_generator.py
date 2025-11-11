#!/usr/bin/env python3
# Create a Python script that generates sample files for practicing Exercise 3
"""
Sample File Generator for Exercise 3 - Linux Scripts Practice
This script generates practice files for bash scripting exercises:
1. program.f90 with x_pos, y_pos variables on different lines
2. Four .txt files with varying file sizes
"""

import os
import random
import string

def create_fortran_file(filename="program.f90"):
    """
    Create a Fortran program file with mixed x_pos and y_pos variables
    on different lines to practice grep and filtering
    """
    content = """      PROGRAM particle_simulation
      IMPLICIT NONE
      REAL :: x_pos, y_pos, z_pos
      REAL :: velocity_x, velocity_y
      INTEGER :: i, n_particles
      
      ! Initialize particle positions
      x_pos = 0.0
      y_pos = 0.0
      z_pos = 1.5
      
      ! Read number of particles
      READ(*,*) n_particles
      
      ! Main simulation loop
      DO i = 1, n_particles
        ! Update position based on velocity
        x_pos = x_pos + velocity_x * 0.01
        y_pos = y_pos + velocity_y * 0.01
        
        ! Print current state
        PRINT *, 'Particle', i
        PRINT *, 'x_pos =', x_pos
        PRINT *, 'Position y_pos =', y_pos
        PRINT *, 'z_pos =', z_pos
        
        ! Check boundaries - x direction
        IF (x_pos > 10.0) THEN
          x_pos = 10.0
        END IF
        
        ! Check boundaries - y direction
        IF (y_pos > 10.0) THEN
          y_pos = 10.0
        END IF
        
        ! Reset if needed
        IF (x_pos < -10.0) THEN
          x_pos = -10.0
        END IF
        
        ! Final position update
        PRINT *, 'Updated x_pos:', x_pos
        IF (y_pos < -10.0) y_pos = -10.0
        PRINT *, 'Final y_pos:', y_pos
      END DO
      
      PRINT *, 'Simulation complete'
      PRINT *, 'Final x_pos =', x_pos
      PRINT *, 'Final y_pos =', y_pos
      
      END PROGRAM particle_simulation
    """
    
    with open(filename, 'w') as f:
        f.write(content)
    print(f"Created {filename}")


def create_text_files():
    """
    Create 4 .txt files with different sizes
    - small.txt: ~500 bytes
    - medium.txt: ~5 KB
    - large.txt: ~50 KB
    - xlarge.txt: ~500 KB
    """
    
    # Small file
    small_content = "This is a small text file.\\n" * 10
    with open("small.txt", 'w') as f:
        f.write(small_content)
    
    # Medium file
    medium_content = "The quick brown fox jumps over the lazy dog. " * 50
    medium_content += "This file is medium sized for practice exercises. " * 50
    with open("medium.txt", 'w') as f:
        f.write(medium_content)
    
    # Large file
    large_content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
    large_content += "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. " * 100
    with open("large.txt", 'w') as f:
        f.write(large_content)
    
    # Extra large file
    xlarge_content = "Data entry: " + ("0123456789 " * 100 + "\\n") * 200
    with open("xlarge.txt", 'w') as f:
        f.write(xlarge_content)
    
    # Print file sizes
    print("\\nCreated text files with sizes:")
    for filename in ["small.txt", "medium.txt", "large.txt", "xlarge.txt"]:
        size = os.path.getsize(filename)
        print(f"  {filename}: {size} bytes")


if __name__ == "__main__":
    create_fortran_file()
    create_text_files()
    print("\\nAll sample files created successfully!")
    print("You can now practice Exercise 3 with these files.")


## Write the Python script to a file
#with open("generate_sample_files.py", 'w') as f:
#    f.write(python_script)
#
#print("Python generator script created successfully!")
#print("\nScript content preview:")
#print(python_script)
