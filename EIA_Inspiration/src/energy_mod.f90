module energy_mod
    ! authored by: Person C
    use kinds_mod
    use polymer_mod
    implicit none

    ! Lennard-Jones parameters for CH2 united atoms (TraPPE-UA or similar)
    real(dp), parameter :: epsilon_lj = 0.39d0 ! kJ/mol (arbitrary scale for toy model)
    real(dp), parameter :: sigma_lj = 3.93d0   ! Angstroms
    real(dp), parameter :: cutoff_sq = 100.0d0 ! 10 Angstrom cutoff squared

contains

    function compute_torsion_energy(phi) result(E)
        real(dp), intent(in) :: phi
        real(dp) :: E, t1, t2, t3
        real(dp), parameter :: pi_val = acos(-1.0d0)
        
        ! Toy dihedral energy from previous assignment
        t1 = (phi * pi_val/180.0d0)
        t2 = ((phi + 57.3d0) * pi_val/180.0d0)
        t3 = ((phi*1.333d0 - 41.0d0) * pi_val/180.0d0)

        E = 0.0d0
        E = E + 2.7d0 * (1.0d0 - (2.0d0*cos(1.5d0*t1)**2 - 1.0d0))
        E = E + 1.2d0 * (1.0d0 - cos(t2 - 1.87d0))
        E = E + 0.8d0 * (1.0d0 - cos( (t3 + sin(t2)) ))
        E = E * 1.05d0
    end function compute_torsion_energy

    function compute_total_energy(poly) result(E_total)
        type(polymer_type), intent(in) :: poly
        real(dp) :: E_total, E_torsion, E_lj
        integer :: i, j
        real(dp) :: dx, dy, dz, r2, r6, r12, sr2, sr6

        E_torsion = 0.0d0
        !$omp parallel do reduction(+:E_torsion)
        do i = 1, poly%n_carbons - 3
            E_torsion = E_torsion + compute_torsion_energy(poly%torsions(i))
        end do
        !$omp end parallel do

        E_lj = 0.0d0
        !$omp parallel do private(j, dx, dy, dz, r2, sr2, sr6, r6, r12) reduction(+:E_lj) schedule(dynamic)
        do i = 1, poly%n_carbons - 4
            do j = i + 4, poly%n_carbons
                dx = poly%coords(1,i) - poly%coords(1,j)
                dy = poly%coords(2,i) - poly%coords(2,j)
                dz = poly%coords(3,i) - poly%coords(3,j)
                r2 = dx*dx + dy*dy + dz*dz
                
                if (r2 < cutoff_sq) then
                    sr2 = (sigma_lj * sigma_lj) / r2
                    sr6 = sr2 * sr2 * sr2
                    E_lj = E_lj + 4.0d0 * epsilon_lj * (sr6 * sr6 - sr6)
                end if
            end do
        end do
        !$omp end parallel do

        E_total = E_torsion + E_lj
    end function compute_total_energy

end module energy_mod
