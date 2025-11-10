program moleculereader
    implicit NONE

    ! Vars for part a
    INTEGER :: N            !Number of Atoms
    INTEGER :: i, j         !Iterators
    ! Vars for file handling
    INTEGER :: ios          !IO Status Checker for File reading
    INTEGER :: unit_in = 10 !Standard unused file number
    CHARACTER(len=100) :: filename = 'q1_molecule_b.xyz'
    ! Store Molecule data, dynamically sized
    ! Use coords(3, N) for (x, y, z) coordinates for N atoms
    REAL, ALLOCATABLE, DIMENSION(:, :) :: coords
    CHARACTER(len=1), ALLOCATABLE, DIMENSION(:) :: symbols
    ! Var for header info (title line)
    CHARACTER(len=256) :: title_line
    
    ! Vars for part b - Max Distance
    REAL :: dist, max_dist = 0.0
    INTEGER :: max_i = 0, max_j = 0
    
    ! Vars for part c - Counting & Mass
    REAL :: molecular_mass = 0.0
    REAL, PARAMETER :: MASS_C = 12.0, MASS_H = 1.0, MASS_O = 16.0
    INTEGER :: C_count = 0, H_count = 0, O_count = 0
    
    
    ! PART A - 
    ! Write a program that reads the information contained in the file
    ! q1_molecule_b.xyz and prints it to the screen
    
    ! Step 1 - Open the file
    open(unit=unit_in,file=filename,status='old',action='read',iostat=ios)
    if (ios /= 0) then
        print *, "Error opening file:", filename
        stop
    end if
    
    ! Step 2 - Read the number of atoms & allocate memory based on N
    read(10, *) N
    allocate(coords(3,N), symbols(N))
    ! Read title line, too
    read(unit_in, '(A)') title_line
    
    ! Step 3 - Read in the atoms using "list-directed input (*) to read
    ! the CHARACTER symbol, closing the file when it's done
    do i = 1, N
        read(10,*,iostat=ios) symbols(i), coords(1,i), coords(2,i), coords(3,i)
        !error handling
        if (ios /= 0) then
            write(*,*) 'Error reading atom data at index ', i
            exit
        endif
    end do
    !Close the file
    close(unit_in)
    
    ! Step 4 - Print the file to screen
    print *, 'Number of atoms: ', N
    print *, 'Title: ', trim(title_line)
    print *, ' '
    write(*,*) '--- Atom Coordinates (Index, Symbol, X, Y, Z)'
    write(*,'(A)') 'Index  Sym.          X           Y           Z'
    write(*,'(A)') '================================================'
    do i = 1, N
        ! F12.5 provides fixed-width floating point formatting (5 decimals)
        write(*, '(I5, 2X, A1, 2X, 3F12.5)') i, symbols(i), coords(:, i)
    end do
    
    
    ! PART B -
    ! Determine the largest distance between any 2 atoms, indicating:
    ! * the indices of the atoms involved (position in list, starting from 1)
    ! * atomic symbols (labels) of the atoms involved
    
    ! Step 1 - (DONE ABOVE) initialize variables needed:
    ! * dist & max_dist (latter is initialized at 0.0)
    ! * counters for indexes
    
    ! Step 2 - run through a double loop, comparing distances of atoms when
    ! inner loop is one atom ahead (preventing double counting), and save the
    ! largest value along with the index
    do i=1, N
        do j = i+1, N
            ! Calcuate squared distance: 
            ! d = sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
            dist = (coords(1,i) - coords(1,j))**2 + &
                   (coords(2,i) - coords(2,j))**2 + &
                   (coords(3,i) - coords(3,j))**2
            dist = sqrt(dist)
            
            if (dist > max_dist) then
                max_dist = dist
                max_i = i
                max_j = j
            end if
        end do
    end do
    
    ! Step 3 - print out results
    print *, ' '
    print *, ' '
    write(*,'(A)') '--- Max Distance Between Particles ---'
    write(*,'(A)') '======================================'
    write(*, '(A, F12.5)') 'Largest distance found:', max_dist
    write(*, '(A, I3, A, A1, A, I3, A, A1, A)') &
             'Between atom:', max_i, ' (', symbols(max_i), ') and atom:', &
              max_j, ' (', symbols(max_j), ')'
    write(*, '(A, A1, A, A1, A)') 'Symbols involved: ', symbols(max_i), ' and ', symbols(max_j), '.'
    
    
    ! PART C -
    ! Determine the number of atoms of each type: C, H, and O, including
    ! the molecular mass
    
    ! Step 1 - use a select case inside a do-loop to iterate through all the atoms
    !          and accumulate their individual counts and overall mass
    do i = 1, N
        select case (symbols(i))
            case ('C')
                C_count = C_count + 1
                molecular_mass = molecular_mass + MASS_C
            case ('H')
                H_count = H_count + 1
                molecular_mass = molecular_mass + MASS_H
            case ('O')
                O_count = O_count + 1
                molecular_mass = molecular_mass + MASS_O
            case default
                ! Handle unexpected atoms
                write(*, *) 'Warning: Unknown atom symbol found: ', symbols(i), ' at index ', i
        end select
    end do
    
    ! Step 2 print out the results
    write(*, *) ' '
    write(*, *) '--- Part (c): Atom Counts and Molecular Mass ---'
    write(*, *) '================================================'
    write(*, *) 'Carbon (C) atoms: ', C_count
    write(*, *) 'Hydrogen (H) atoms: ', H_count
    write(*, *) 'Oxygen (O) atoms: ', O_count
    write(*, '(A, F10.3)') 'Total Molecular Mass:', molecular_mass
    
    
    ! Deallocate dynamic memory
    deallocate(coords, symbols)
    
end program 