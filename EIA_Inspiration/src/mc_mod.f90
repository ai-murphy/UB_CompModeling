module mc_mod
    ! authored by: Person B
    use kinds_mod
    use polymer_mod
    use energy_mod
    implicit none

    real(dp), parameter :: kb = 0.008314d0 ! kJ/(mol K)
    
contains

    subroutine mc_step(poly, T, max_displacement, accepted, current_energy)
        type(polymer_type), intent(inout) :: poly
        real(dp), intent(in) :: T, max_displacement
        logical, intent(out) :: accepted
        real(dp), intent(inout) :: current_energy
        
        integer :: r_index
        real(dp) :: r_val
        real(dp) :: old_torsion, old_energy, new_energy, delta_E

        ! Pick random torsion [1, n_carbons - 3]
        call random_number(r_val)
        r_index = 1 + int(r_val * (poly%n_carbons - 3))
        if(r_index > poly%n_carbons - 3) r_index = poly%n_carbons - 3

        old_torsion = poly%torsions(r_index)
        old_energy = current_energy

        ! Propose new torsion
        call random_number(r_val)
        poly%torsions(r_index) = old_torsion + (2.0d0 * r_val - 1.0d0) * max_displacement
        
        ! Periodic boundaries (-180, 180]
        if (poly%torsions(r_index) > 180.0d0) poly%torsions(r_index) = poly%torsions(r_index) - 360.0d0
        if (poly%torsions(r_index) <= -180.0d0) poly%torsions(r_index) = poly%torsions(r_index) + 360.0d0

        ! Rebuild coordinates and compute energy
        call build_coords(poly)
        new_energy = compute_total_energy(poly)

        delta_E = new_energy - old_energy

        accepted = .false.
        if (delta_E < 0.0d0) then
            accepted = .true.
        else
            call random_number(r_val)
            if (r_val < exp(-delta_E / (kb * T))) then
                accepted = .true.
            end if
        end if

        if (accepted) then
            current_energy = new_energy
        else
            ! Revert
            poly%torsions(r_index) = old_torsion
            call build_coords(poly)
            ! energy remains old_energy
        end if

    end subroutine mc_step

end module mc_mod
