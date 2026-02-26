program main
    ! authored by: Person B, Person C
    use kinds_mod
    use polymer_mod
    use energy_mod
    use mc_mod
    implicit none

    type(polymer_type) :: poly
    integer, parameter :: N_atoms = 500
    integer, parameter :: N_steps = 10000
    integer, parameter :: output_freq = 10
    real(dp), parameter :: T = 300.0d0
    real(dp), parameter :: max_disp = 10.0d0
    
    integer :: step, accepted_moves
    real(dp) :: current_energy, r_ee, r_g
    logical :: accepted
    integer :: u_traj, u_energy

    call random_seed()
    
    ! Initialize polymer
    call init_polymer(poly, N_atoms)
    
    ! Initial energy
    current_energy = compute_total_energy(poly)
    accepted_moves = 0
    
    ! Open output files
    open(newunit=u_traj, file='trajectory.dat', status='replace')
    open(newunit=u_energy, file='energy.dat', status='replace')
    write(u_energy, '(A)') '# Step Energy(kJ/mol) AcceptanceRatio R_ee R_g'
    
    ! Dump initial state
    call compute_observables(poly, r_ee, r_g)
    call dump_torsions(poly, u_traj, 0)
    write(u_energy, '(I8, 1X, E16.6, 3F12.4)') 0, current_energy, 0.0d0, r_ee, r_g
    call save_pdb(poly, 'initial_conformation.pdb')

    print *, 'Starting MC simulation for N=', N_atoms, ' at T=', T, 'K'
    
    do step = 1, N_steps
        call mc_step(poly, T, max_disp, accepted, current_energy)
        
        if (accepted) accepted_moves = accepted_moves + 1
        
        if (mod(step, output_freq) == 0) then
            call compute_observables(poly, r_ee, r_g)
            write(u_energy, '(I8, 1X, E16.6, 3F12.4)') step, current_energy, real(accepted_moves, dp)/real(step, dp), r_ee, r_g
            call dump_torsions(poly, u_traj, step)
        end if
    end do
    
    call save_pdb(poly, 'final_conformation.pdb')
    
    close(u_traj)
    close(u_energy)
    
    print *, 'Simulation finished.'
    print *, 'Total accepted moves: ', accepted_moves
    print *, 'Acceptance ratio: ', real(accepted_moves, dp)/real(N_steps, dp)

    call destroy_polymer(poly)

contains

    subroutine dump_torsions(poly, unit, step)
        type(polymer_type), intent(in) :: poly
        integer, intent(in) :: unit, step
        integer :: i
        write(unit, '(I8)', advance='no') step
        do i = 1, poly%n_carbons - 3
            write(unit, '(F10.3)', advance='no') poly%torsions(i)
        end do
        write(unit, *) ''
    end subroutine dump_torsions

end program main
