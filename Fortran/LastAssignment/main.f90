
program molecule_analyzer
    use utils_module
    use mass_module
    use distance_module
    use groups_module
    implicit none

    character(len=256) :: filename
    integer :: atom_ct, i, ios
    character(len=4), allocatable :: types(:)
    real(kind=8), allocatable :: x(:), y(:), z(:)
    real(kind=8) :: molar_mass
    type(dist_info) :: overall, nonH
    integer :: n_hydroxyl, n_carbonyl

    print *, 'Enter .xyz filename (ex: molecule.xyz):'
    read(*,'(A)') filename

    call read_xyz(trim(filename), atom_ct, types, x, y, z, ios)
    if (ios /= 0) then
        print *, 'Error reading file: ', trim(filename)
        stop 1
    end if

    molar_mass = compute_molar_mass(atom_ct, types)
    print *
    write(*,'(A,F10.4,A)') 'Molar mass (g/mol): ', molar_mass, ''

    call find_minmax_all(atom_ct, types, x, y, z, overall)
    write(*,'(A)') ''
    print *, 'Overall distances:'
    write(*,'(A,I6,A,A,2F12.5)') 'Min distance: atom ', overall%min_i, ', ', trim(overall%min_type_i), overall%min_dist
    write(*,'(A,I6,A,A,2F12.5)') 'Max distance: atom ', overall%max_i, ', ', trim(overall%max_type_i), overall%max_dist
    print *, 'Min pair: (', overall%min_i, ',', overall%min_j, ') types: ', trim(overall%min_type_i), '-', trim(overall%min_type_j)
    print *, 'Max pair: (', overall%max_i, ',', overall%max_j, ') types: ', trim(overall%max_type_i), '-', trim(overall%max_type_j)
    print *, 'Min distance (Å): ', overall%min_dist
    print *, 'Max distance (Å): ', overall%max_dist

    call find_minmax_nonH(atom_ct, types, x, y, z, nonH)
    if (nonH%count_pairs > 0) then
        write(*,'(A)') ''
        print *, 'Non-H distances:'
        print *, 'Min non-H pair: (', nonH%min_i, ',', nonH%min_j, ') types: ', trim(nonH%min_type_i), '-', trim(nonH%min_type_j)
        print *, 'Min non-H distance (Å): ', nonH%min_dist
        print *, 'Max non-H pair: (', nonH%max_i, ',', nonH%max_j, ') types: ', trim(nonH%max_type_i), '-', trim(nonH%max_type_j)
        print *, 'Max non-H distance (Å): ', nonH%max_dist
    else
        print *, 'No non-H atom pairs found (all atoms are H or insufficient non-H atoms).'
    end if

    n_hydroxyl = count_hydroxyls(atom_ct, types, x, y, z)
    n_carbonyl = count_carbonyls(atom_ct, types, x, y, z)

    write(*,'(A,I6)') 'Number of hydroxyl groups (O-H 0.94-1.05 A): ', n_hydroxyl
    write(*,'(A,I6)') 'Number of carbonyl groups (C=O 1.20-1.30 A): ', n_carbonyl

    deallocate(types, x, y, z)

end program molecule_analyzer
