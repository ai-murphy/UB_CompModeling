      PROGRAM particle_simulation
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
    